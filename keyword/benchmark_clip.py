from PIL import Image
from transformers import CLIPProcessor, CLIPModel
import numpy as np
import sys
import cv2
import tempfile
import os
import glob

def sample_frame(video_filepath):
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

    # get 5 random frames as well
    random_frames = np.random.choice(len(frames), 5)

    returning_frames = []
    returning_frames.append(frames[min_diff_idx])
    for idx in random_frames:
        returning_frames.append(frames[idx])
    # save the frame into directory
    # cv2.imwrite('./frames/frame_diff.jpg', frames[min_diff_idx])
    return returning_frames

def extract_keyword(model, processor, pil_images, labels):
    hashtags = [f"#{label.split()[-1]}" for label in labels]
    inputs = processor(text=labels, images=pil_images, return_tensors="pt", padding=True)

    outputs = model(**inputs)
    logits_per_image = outputs.logits_per_image

    probs = logits_per_image.softmax(dim=1)
    sorted_probs, sorted_labels = probs.sort(dim=1, descending=True)

    # len_top5 = min(5, len(sorted_probs[0]))
    len_top5 = 5
    top5 = []

    for i in range(len_top5):
        for j in range(len(pil_images)):
            if sorted_probs[j][i] > 0.2:
                top5.append((labels[sorted_labels[j][i]], f"{sorted_probs[j][i].item():.3f}"))
            # top5.append((labels[sorted_labels[0][i]], f"{sorted_probs[0][i].item():.3f}"))
        # if sorted_probs[0][i] > 0.2:
            # top5.append((labels[sorted_labels[0][i]], f"{sorted_probs[0][i].item():.3f}"))
    return top5

if __name__ == "__main__":
    model = CLIPModel.from_pretrained("openai/clip-vit-base-patch16")
    processor = CLIPProcessor.from_pretrained("openai/clip-vit-base-patch16")

    labels = []
    with open('./labels.txt', 'r') as f:
        labels = [line.strip() for line in f.readlines()]

    true_positive_count = 0
    wrong_files = []

    files = glob.glob('/Users/minsuyoon/Desktop/School/23-1/창의적통합설계2/real_life_violence/Real Life Violence Dataset/NonViolence/*')
    files = [file for file in files if 'mp4' in file]
    with open('non_output.txt', 'w') as wf:
        for i, video_file in enumerate(files):
            frames = sample_frame(video_file)
            # opencv uses BGR by default, change to RGB for PIL
            frames = [cv2.cvtColor(frame, cv2.COLOR_BGR2RGB) for frame in frames]
            pil_images = [Image.fromarray(frame) for frame in frames]

            top5 = extract_keyword(model, processor, pil_images, labels)

            wf.write(os.path.basename(video_file)+"\n")
            wf.write(str(top5)+"\n")
            # if labels[0] in keywords or labels[1] in keywords or labels[2] in keywords:
            keywords = [keyword[0] for keyword in top5]
            if 'violence' in keywords or 'fight' in keywords or 'This photo contains violence.' in keywords:
                true_positive_count += 1
            else:
                wrong_files.append(os.path.basename(video_file))

    true_positive_rate = true_positive_count / len(files)
    print(true_positive_rate)
    print(wrong_files)
