#!/usr/bin/env python
# coding: utf-8
from matplotlib.pyplot import figure
from skimage.draw import line, polygon, circle, ellipse
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
import cv2
import numpy as np
from skimage.exposure import rescale_intensity
from skimage.exposure import equalize_hist, adjust_log, adjust_gamma
from skimage.color import rgb2gray
from scipy import ndimage as ndi
import matplotlib.pyplot as plt
from skimage.feature import peak_local_max
from skimage import data, img_as_float
import mediapipe as mp

mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_face_mesh = mp.solutions.face_mesh


def landmark_detection(image):
    IMAGE_FILES = [image]
    drawing_spec = mp_drawing.DrawingSpec(thickness=1, circle_radius=1)
    im = cv2.imread(image)
    with mp_face_mesh.FaceMesh(
            static_image_mode=True,
            max_num_faces=1,
            refine_landmarks=True,
            min_detection_confidence=0.9) as face_mesh:
        for idx, file in enumerate(IMAGE_FILES):
            image = cv2.imread(file)
            results = face_mesh.process(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
            if not results.multi_face_landmarks:
                continue
            annotated_image = image.copy()
            for face_landmarks in results.multi_face_landmarks:
                mp_drawing.draw_landmarks(
                    image=annotated_image,
                    landmark_list=face_landmarks,
                    connections=mp_face_mesh.FACEMESH_TESSELATION,
                    landmark_drawing_spec=None,
                    connection_drawing_spec=mp_drawing_styles
                        .get_default_face_mesh_tesselation_style())
                mp_drawing.draw_landmarks(
                    image=annotated_image,
                    landmark_list=face_landmarks,
                    connections=mp_face_mesh.FACEMESH_CONTOURS,
                    landmark_drawing_spec=None,
                    connection_drawing_spec=mp_drawing_styles
                        .get_default_face_mesh_contours_style())
                mp_drawing.draw_landmarks(
                    image=annotated_image,
                    landmark_list=face_landmarks,
                    connections=mp_face_mesh.FACEMESH_IRISES,
                    landmark_drawing_spec=None,
                    connection_drawing_spec=mp_drawing_styles
                        .get_default_face_mesh_iris_connections_style())

            cv2.imwrite('tmp/' + str(idx) + '.png', annotated_image)

    return im, results.multi_face_landmarks


def crop_photo_len(image):
    crop1 = -1
    crop2 = -1

    for i in range(len(image)):
        if np.sum(image[i, :, 0]) != 0 and crop1 == -1:
            crop1 = i - 1
        elif crop1 != -1 and crop2 == -1 and np.sum(image[i, :, 0]) == 0:
            crop2 = i
    return crop1, crop2


def crop_photo_width(image):
    crop1 = -1
    crop2 = -1

    for i in range(len(image[0])):
        if np.sum(image[:, i, 0]) != 0 and crop1 == -1:
            crop1 = i - 1
        elif crop1 != -1 and crop2 == -1 and np.sum(image[:, i, 0]) == 0:
            crop2 = i
    return crop1, crop2


def crop_photo(image):
    len1, len2 = crop_photo_len(image)
    width1, width2 = crop_photo_width(image)
    return image[len1:len2, width1:width2, :]


def divide_parts(image, landmarks, mode=None):
    border_dict = {
        "silhouette_lst": [10, 338, 297, 332, 284, 251, 389, 356, 454, 323, 361, 288, 397, 365, 379, 378, 400, 377, 152,
                           148, 176, 149, 150, 136, 172, 58, 132, 93, 234, 127, 162, 21, 54, 103, 67, 109],
        "lips_lst": [61, 185, 40, 39, 37, 0, 267, 269, 270, 409, 291, 146, 91, 181, 84, 17, 314, 405, 321, 375],
        "right_eye_lst": [246, 161, 160, 159, 158, 157, 173, 33, 7, 163, 144, 145, 153, 154, 155, 133],
        "left_eye_lst": [466, 388, 387, 386, 385, 384, 398, 263, 249, 390, 373, 374, 380, 381, 382, 362],
        "left_cheek": [143, 34, 127, 234, 93, 132, 58, 172, 138, 135, 214, 57, 186, 92, 165, 203, 36, 100, 47, 114, 128,
                       232, 231, 230, 229, 228, 31],
        "right_cheek": [446, 265, 372, 264, 356, 454, 323, 361, 288, 397, 367, 364, 434, 432, 287, 410, 436, 426, 266,
                        329, 277, 450, 449, 448, 261],
        "chin": [172, 138, 192, 214, 212, 57, 146, 91, 181, 84, 17, 314, 405, 321, 375, 287, 432, 434, 416, 435, 288,
                 397, 365, 379, 378, 400, 377, 152, 148, 176, 149, 150, 136],
        "forehead": [162, 21, 54, 103, 67, 109, 10, 338, 297, 332, 284, 251, 389, 356, 264, 372, 383, 300, 293, 334,
                     296, 336, 9, 107, 66, 105, 63, 70, 156, 139]

        }
    if mode == "face":
        copy = np.copy(image)
        copy = exclude_polygon(landmarks, border_dict["silhouette_lst"], copy, "-")
        copy = crop_photo(copy)
        return copy

    im_lst = []
    copy = np.copy(image)
    for i in list(border_dict.keys())[4:]:
        copy = np.copy(image)
        copy = exclude_polygon(landmarks, border_dict[i], copy, "-")
        copy = crop_photo(copy)
        im_lst.append(copy)

    return im_lst


def exclude_polygon(landmarks, lst, image, typ):
    img = np.copy(image)
    points = []
    for i in lst:
        points.append(
            ((landmarks[0].landmark[i].y * len(image[:, 0, 0])), (landmarks[0].landmark[i].x * len(image[0, :, 0]))))

    # fill polygon
    poly = np.array(points)
    rr, cc = polygon(poly[:, 0], poly[:, 1], img.shape)
    if typ == "-":
        img[rr, cc, 0] = 255
        img[rr, cc, 1] = 255
        img[rr, cc, 2] = 255
        return image - img
    img[rr, cc, 0] = 0
    img[rr, cc, 1] = 0
    img[rr, cc, 2] = 0

    return img


def resize_parts(face_res, parts):
    resized_parts = []
    counter = 0
    print(face_res)
    for part in parts:
        counter += 1
        part_shape = part.shape
        print(part_shape)
        part = Image.fromarray(part)
        print((int(part_shape[0]), (2448 / face_res[0])))
        resized_image = part.resize(
            (int(part_shape[1] * (1000 / face_res[1])), (int(part_shape[0] * (1745 / face_res[0])))))
        part = np.array(resized_image)
        resized_parts.append(part)
    return resized_parts


def preprocessing(image):
    image = rescale_intensity(img, in_range=(50, 220))
    rgb_planes = cv2.split(image)
    result_planes = []
    result_norm_planes = []
    for plane in rgb_planes:
        dilated_img = cv2.dilate(plane, np.ones((7, 7), np.uint8))
        bg_img = cv2.medianBlur(dilated_img, 21)
        diff_img = 255 - cv2.absdiff(plane, bg_img)
        norm_img = cv2.normalize(diff_img, None, alpha=0, beta=255, norm_type=cv2.NORM_MINMAX, dtype=cv2.CV_8UC1)
        result_planes.append(diff_img)
        result_norm_planes.append(norm_img)

    result = cv2.merge(result_planes)
    result_norm = cv2.merge(result_norm_planes)
    img_gray = result[:, :, 0]
    img_gray = (img_gray * 255).astype(np.uint8)
    return img_gray


def shadow_removal(image):
    rgb_planes = cv2.split(image)
    result_planes = []
    result_norm_planes = []
    for plane in rgb_planes:
        dilated_img = cv2.dilate(plane, np.ones((7, 7), np.uint8))
        bg_img = cv2.medianBlur(dilated_img, 21)
        diff_img = 255 - cv2.absdiff(plane, bg_img)
        norm_img = cv2.normalize(diff_img, None, alpha=0, beta=255, norm_type=cv2.NORM_MINMAX, dtype=cv2.CV_8UC1)
        result_planes.append(diff_img)
        result_norm_planes.append(norm_img)

    result = cv2.merge(result_planes)
    result_norm = cv2.merge(result_norm_planes)
    img_gray = result[:, :, 0]
    img_gray = (img_gray * 255).astype(np.uint8)
    return img_gray


def acne_detection(processed_image):
    image_max = ndi.maximum_filter(img_gray, size=4, mode='constant')
    coordinates = peak_local_max(img_gray, min_distance=10, threshold_rel=0.25)
    patches = []
    new_coordinates = []
    for coordinate in coordinates:
        im = image[(coordinate[0] - 5):(coordinate[0] + 5), (coordinate[1] - 5):(coordinate[1] + 5), :]
        if list(im.flatten()).count(0) > 10:
            continue
        patches.append(image[(coordinate[0] - 30):(coordinate[0] + 30), (coordinate[1] - 30):(coordinate[1] + 30), :])
        new_coordinates.append(coordinate)
    return patches, new_coordinates


def pipeline(path):
    image, landmarks = landmark_detection(path)
    parts = divide_parts(image, landmarks)
    face = divide_parts(image, landmarks, "face")
    parts = resize_parts(list(face.shape)[:2], parts)
    img = parts[0]
    image = rescale_intensity(img, in_range=(120, 200))
    img_gray = shadow_removal(image)
    return acne_detection(img_gray)


patches, coordinates = pipeline("sample.jpg")

