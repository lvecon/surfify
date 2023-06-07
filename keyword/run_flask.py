from PIL import Image
import numpy as np
import sys
import cv2
import tempfile
import os
from flask import Flask, request, jsonify
import clip
import torch
import logging
import time
import yaml

device = "cuda" if torch.cuda.is_available() else "cpu"
model, preprocess = clip.load("ViT-B/32", device=device)

with open('./translation.yaml','r') as f:
    translation = yaml.safe_load(f)
print(translation)

filtering_labels = []
with open('filtering_labels.txt', 'r') as f:
    filtering_labels = [line.strip() for line in f.readlines()]


tagging_labels = []
with open('tagging_labels.txt', 'r') as f:
    tagging_labels = [line.strip() for line in f.readlines()]

app = Flask(__name__)

def sample_frames(video_filepath):
    vidcap = cv2.VideoCapture(video_filepath)
    total_frames = int(vidcap.get(cv2.CAP_PROP_FRAME_COUNT))
    random_frames_idx = sorted(list(np.random.choice(range(total_frames), 5)))

    prev_image = None
    curret_image = None
    min_diff_image = None

    min_diff = float('inf')
    count = 0
    returning_frames = []

    for i in range(total_frames):
        success, current_image = vidcap.read()
        if not success:
            break

        if prev_image is not None:
            diff = np.mean(np.abs(prev_image - current_image))
            if diff < min_diff:
                min_diff = diff
                min_diff_image = current_image

        if i in random_frames_idx:
            returning_frames.append(current_image)

        prev_image = current_image

    returning_frames.insert(0, min_diff_image)
    vidcap.release()

    return returning_frames

def should_filter(image_features, text_features):
    image_features /= image_features.norm(dim=-1, keepdim=True)
    text_features /= text_features.norm(dim=-1, keepdim=True)
    text_probs = (100.0 * image_features @ text_features.T).softmax(dim=-1)
    top_probs, top_labels = text_probs.topk(5, dim=-1)

    flag = 0

    for i in range(len(top_probs)):
        for j in range(len(top_probs[i])):
            if top_probs[i][j] > 0.2:
                if 'violence' in filtering_labels[top_labels[i][j]] or \
                   "This photo contains violence." in filtering_labels[top_labels[i][j]] or \
                   "Beautiful Blonde babe gets fucked from behind" in filtering_labels[top_labels[i][j]] or \
                   'Awesome fuck followed by cumming deep in her throat' in filtering_labels[top_labels[i][j]]:
                    flag = 1
    return flag

def get_tagging_predicted_labels(image_features, text_features):
    image_features /= image_features.norm(dim=-1, keepdim=True)
    text_features /= text_features.norm(dim=-1, keepdim=True)
    text_probs = (100.0 * image_features @ text_features.T).softmax(dim=-1)
    top_probs, top_labels = text_probs.topk(5, dim=-1)

    predicted_labels = []
    for i in range(len(top_probs)):
        for j in range(len(top_probs[i])):
            if top_probs[i][j] > 0.2:
                predicted_labels.append((tagging_labels[top_labels[i][j]], top_probs[i][j].item()))

    predicted_labels.sort(key=lambda x: x[1], reverse=True)
    return predicted_labels

def extract_keyword(images):
    images = [preprocess(image) for image in images]

    image_input = torch.tensor(np.stack(images))
    filtering_text_tokens = clip.tokenize(filtering_labels)
    with torch.no_grad():
        image_features = model.encode_image(image_input).float()
        text_features = model.encode_text(filtering_text_tokens).float()

    returning_json = {"flag": 0, "labels": []}
    flag = should_filter(image_features, text_features)

    if flag:
        returning_json["flag"] = 1
    else:
        tagging_text_tokens = clip.tokenize(tagging_labels)
        with torch.no_grad():
            text_features = model.encode_text(tagging_text_tokens).float()

        predicted_labels = get_tagging_predicted_labels(image_features, text_features)
        print(predicted_labels)
        predicted_set = set()
        # select the top 5 non-overlapping labels with the highest probability
        for i in range(len(predicted_labels)):
            if len(returning_json["labels"]) >= 5:
                break
            if predicted_labels[i][0] not in predicted_set:
                try:
                    returning_json["labels"].append(translation[predicted_labels[i][0]])
                except KeyError:
                    returning_json["labels"].append(predicted_labels[i][0])
                predicted_set.add(predicted_labels[i][0])
    print(returning_json)
    return returning_json

@app.route("/health")
def health():
    print('check')
    return jsonify([])

@app.route('/predict_video', methods=['POST'])
def predict_video():
    # get video from request
    video_file = request.files['video']
    app.logger.info(f"torch running on {device}")
    app.logger.info("FLASK HAS RECEIVED THE VIDEO")
    with tempfile.TemporaryDirectory() as tmpdir:
        video_filepath = os.path.join(tmpdir, 'video.mp4')
        video_file.save(video_filepath)

        start_time = time.time()
        frames = sample_frames(video_filepath)
        end_time = time.time()

        app.logger.info(f"{end_time - start_time} for frame sampling")
        # opencv uses BGR by default, change to RGB for PIL
        frames = [cv2.cvtColor(frame, cv2.COLOR_BGR2RGB) for frame in frames]
        pil_images = [Image.fromarray(frame) for frame in frames]

        start_time = time.time()
        keywords = extract_keyword(pil_images)
        end_time = time.time()

        app.logger.info(f"{end_time - start_time} for keyword extraction")

        return jsonify(keywords)
    return jsonify([])

@app.route('/predict_image', methods=['POST'])
def predict_image():
    image = [Image.open(request.files['image'])]
    app.logger.info(f"torch running on {device}")
    app.logger.info("FLASK HAS RECEIVED THE IMAGE")

    keywords = extract_keyword(image)
    return jsonify(keywords)

if __name__ == "__main__":
    app.run(port=5010, debug=True, host="0.0.0.0")
