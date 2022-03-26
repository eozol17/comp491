import matplotlib.pyplot as plt
from scipy.ndimage import distance_transform_edt, gaussian_filter
from skimage import io
from skimage.color import rgb2gray
from skimage.filters import threshold_otsu
from skimage.morphology import h_maxima, local_maxima
import numpy as np
import cv2
from skimage.morphology import disk, binary_closing, binary_opening, binary_dilation
from scipy import ndimage as ndi
from skimage.segmentation import watershed
from skimage.feature import peak_local_max
from skimage.feature import canny
import image_processing

fig, axes = plt.subplots(1, 2, figsize=(50, 30), sharex=True, sharey=True)
ax = axes.ravel()


def ObtainForegroundMask(img):
    img = cv2.imread("image.jpeg")
    lab = cv2.cvtColor(image_processing.new[0], cv2.COLOR_RGB2LAB)

    L, A, B = cv2.split(lab)

    dilated_img = cv2.dilate(A, np.ones((5, 5), np.uint8))
    bg_img = cv2.medianBlur(dilated_img, 5)
    diff_img = 255 - cv2.absdiff(A, bg_img)
    norm_img = cv2.normalize(diff_img, None, alpha=0, beta=255, norm_type=cv2.NORM_MINMAX, dtype=cv2.CV_8UC1)

    threshold = threshold_otsu(norm_img)
    binary = norm_img >= threshold - 45
    binary = binary.astype(np.uint8)

    # ax[0].imshow(cv2.cvtColor(new[0], cv2.COLOR_BGR2RGB))
    # ax[1].imshow(binary, cmap = "Greys")
    return binary


def FindAcneLocations(image, foregroundMap):
    # loads the image
    image = rgb2gray(image)
    edges = canny(image, sigma=0.01, low_threshold=0.10, high_threshold=0.20)

    edges = rgb2gray(edges)

    threshold2 = threshold_otsu(edges)

    binary_edge = edges >= threshold2
    binary_edge = binary_edge.astype(np.uint8)

    foregroundMap = foregroundMap - binary_edge

    distance_trans = distance_transform_edt(foregroundMap)
    maximized = h_maxima(distance_trans, 2)
    maximized = local_maxima(maximized)
    maximized = maximized.astype(np.uint8)

    return maximized


def FindAcneBoundaries(image, foregroundMap, cellLocations):
    image = rgb2gray(image)
    edges = canny(image, sigma=1, low_threshold=0.30, high_threshold=0.50)
    edges = rgb2gray(edges)

    threshold2 = threshold_otsu(edges)
    binary_edge = edges >= threshold2
    binary_edge = binary_edge.astype(np.uint8)
    foregroundMap = foregroundMap - binary_edge
    marked_cellLocations = ndi.label(cellLocations)[0]
    segmentation = watershed(image, markers=marked_cellLocations, mask=foregroundMap)
    return segmentation


ax[0].imshow(cv2.cvtColor(image_processing.new[0], cv2.COLOR_BGR2RGB))
ax[1].imshow(FindAcneLocations(image_processing.new[0], ObtainForegroundMask(image_processing.new[0])))
plt.imshow(FindAcneBoundaries(image_processing.new[0], ObtainForegroundMask(image_processing.new[0]),
                                 FindAcneLocations(image_processing.new[0], ObtainForegroundMask(image_processing.new[0]))))