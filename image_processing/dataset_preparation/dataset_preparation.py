import cv2
import numpy as np


def crop_acne(original_image, annotated_image):
    annotation = cv2.imread(annotated_image)
    results = []
    for i in range(len(annotation)):
        for j in range(len(annotation[0])):
            if annotation[i, j, 0] == 0 and annotation[i, j, 1] == 255 and annotation[i, j, 2] == 0:
                results.append((i, j))
    image = cv2.imread(original_image)
    patches = []
    for result in results:
        patches.append(image[(result[0] - 60):(result[0] + 60), (result[1] - 60):(result[1] + 60), :])
    return patches
