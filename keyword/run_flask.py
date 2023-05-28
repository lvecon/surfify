from PIL import Image
import numpy as np
import sys
import cv2
import tempfile
import os
from flask import Flask, request, jsonify
import clip
import torch

model, preprocess = clip.load("ViT-B/32")
app = Flask(__name__)

def sample_frames(video_filepath):
    vidcap = cv2.VideoCapture(video_filepath)

    success,image = vidcap.read()
    count = 0
    frames = []
    while success:
      frames.append(image)
      success,image = vidcap.read()
      count += 1

    diffs = []
    for i in range(1, len(frames)):
        diffs.append(np.mean(np.abs(frames[i-1] - frames[i])))

    min_diff = min(diffs)
    min_diff_idx = diffs.index(min_diff)

    # save the frame into directory
    # cv2.imwrite('./frames/frame_diff.jpg', frames[min_diff_idx])
    return [frames[min_diff_idx]]

def extract_keyword(images, labels):
    # hashtags = [f"#{label.split()[-1]}" for label in labels]
    images = [preprocess(image) for image in images]
    image_input = torch.tensor(np.stack(images))

    image_features = model.encode_image(image_input).float()
    text_tokens = clip.tokenize(labels)

    with torch.no_grad():
        image_features = model.encode_image(image_input).float()
        text_features = model.encode_text(text_tokens).float()

    image_features /= image_features.norm(dim=-1, keepdim=True)
    text_features /= text_features.norm(dim=-1, keepdim=True)
    text_probs = (100.0 * image_features @ text_features.T).softmax(dim=-1)
    top_probs, top_lables = text_probs.topk(5, dim=-1)

    top5 = []

    for i in range(len(images)):
        for j in range(len(top_probs[i])):
            if top_probs[i][j] > 0.2:
                top5.append((labels[top_lables[i][j]], f"{top_probs[i][j].item():.3f}"))

    return top5

@app.route("/health")
def health():
    print('check')
    return jsonify([])

@app.route('/predict_video', methods=['POST'])
def predict_video():
    labels = []
    with open('labels.txt', 'r') as f:
        labels = [line.strip() for line in f.readlines()]

    # get video from request
    video_file = request.files['video']
    with tempfile.TemporaryDirectory() as tmpdir:
        video_filepath = os.path.join(tmpdir, 'video.mp4')
        video_file.save(video_filepath)

        frames = sample_frames(video_filepath)
        # opencv uses BGR by default, change to RGB for PIL
        frames = [cv2.cvtColor(frame, cv2.COLOR_BGR2RGB) for frame in frames]
        pil_images = [Image.fromarray(frame) for frame in frames]

        keywords = extract_keyword(pil_images, labels)
        return jsonify(keywords)
    return jsonify([])

@app.route('/predict_image', methods=['POST'])
def predict_image():
    image = [Image.open(request.files['image'])]
    with open('labels.txt') as f:
        keywords = [x.strip() for x in f.readlines()]

    keywords = extract_keyword(image, keywords)
    return jsonify(keywords)

if __name__ == "__main__":
    app.run(port=5010, debug=True, host="0.0.0.0")
