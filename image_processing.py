import matplotlib.pyplot as plt
from matplotlib.pyplot import figure
import numpy as np
import matplotlib.pyplot as plt

from skimage.draw import line, polygon, circle, ellipse
import numpy as np

import matplotlib.pyplot as plt
from matplotlib.pyplot import figure
import cv2
import mediapipe as mp

mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_face_mesh = mp.solutions.face_mesh


def landmark_detection(image):
    IMAGE_FILES = [image]
    drawing_spec = mp_drawing.DrawingSpec(thickness=1, circle_radius=1)
    image = cv2.imread(file)
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

    return image, results.multi_face_landmarks

def crop_photo_len(image):
    crop1 = -1
    crop2 = -1

    for i in range(len(image)):
        if np.sum(image[i,:,0]) != 0 and crop1 == -1:
            crop1 = i-1
        elif  crop1 != -1 and crop2 == -1 and np.sum(image[i,:,0]) == 0:
            crop2 =i
    return crop1, crop2

def crop_photo_width(image):
    crop1 = -1
    crop2 = -1

    for i in range(len(image[0])):
        if np.sum(image[:,i,0]) != 0 and crop1 == -1:
            crop1 = i-1
        elif  crop1 != -1 and crop2 == -1 and np.sum(image[:,i,0]) == 0:
            crop2 =i
    return crop1, crop2

def crop_photo(image):
    len1, len2 = crop_photo_len(image)
    width1, width2 = crop_photo_width(image)
    return image[len1:len2,width1:width2,:]


def divide_parts(image, landmarks):
    border_dict = {
        "silhouette_lst": [10, 338, 297, 332, 284, 251, 389, 356, 454, 323, 361, 288, 397, 365, 379, 378, 400, 377, 152,
                           148, 176, 149, 150, 136, 172, 58, 132, 93, 234, 127, 162, 21, 54, 103, 67, 109],
        "lips_lst": [61, 185, 40, 39, 37, 0, 267, 269, 270, 409, 291, 146, 91, 181, 84, 17, 314, 405, 321, 375],
        "right_eye_lst": [246, 161, 160, 159, 158, 157, 173, 33, 7, 163, 144, 145, 153, 154, 155, 133],
        "left_eye_lst": [466, 388, 387, 386, 385, 384, 398, 263, 249, 390, 373, 374, 380, 381, 382, 362],
        "left_cheek": [226, 25, 143, 34, 127, 234, 93, 132, 58, 172, 138, 135, 214, 57, 186, 92, 165, 203, 129, 209,
                       126, 47, 121, 232, 26, 22, 23, 24, 110, 25],
        "right_cheek": [446, 265, 372, 264, 356, 454, 323, 361, 288, 397, 367, 364, 434, 432, 287, 410, 436, 426, 266,
                        329, 277, 450, 449, 448, 261],
        "chin": [172, 138, 192, 214, 212, 57, 146, 91, 181, 84, 17, 314, 405, 321, 375, 287, 432, 434, 416, 435, 288,
                 397, 365, 379, 378, 400, 377, 152, 148, 176, 149, 150, 136],
        "forehead": [162, 21, 54, 103, 67, 109, 10, 338, 297, 332, 284, 251, 389, 356, 264, 372, 383, 300, 293, 334,
                     296, 336, 9, 107, 66, 105, 63, 70, 156, 139]

        }
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
        img[rr, cc, 0] = 0
        img[rr, cc, 1] = 0
        img[rr, cc, 2] = 0
        return image - img
    img[rr, cc, 0] = 0
    img[rr, cc, 1] = 0
    img[rr, cc, 2] = 0

    return img


image, landmarks = landmark_detection("sample.jpg")
new = divide_parts(image, landmarks)

