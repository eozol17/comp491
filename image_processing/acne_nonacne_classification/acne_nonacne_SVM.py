# -*- coding: utf-8 -*-
"""Acne/NonAcne Training.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1PaBVqWc8AAFmRSH5_HMhF2nIVxgL7ub5
"""

from google.colab import drive
drive.mount("/content/drive")

import numpy as np
import time
import os
import copy
from PIL import Image
import matplotlib.pyplot as pyplot
from skimage import io
from skimage.measure import shannon_entropy
from skimage.color import rgb2gray
from skimage.feature import canny
from skimage.filters import threshold_otsu
from skimage.measure import regionprops
from skimage.morphology import disk, binary_closing, binary_opening, binary_dilation
import numpy as np
import cv2.cv2
import math
from math import log
import scipy.stats
import tensorflow as tf
from statistics import stdev, mean
from sklearn.model_selection import train_test_split

# stores the labels in an array
labels = []
size_open_comedone = len(os.listdir("/content/drive/MyDrive/Comp491 Skincare Project/patch dataset/open comedone/"))
for i in range(1, size_open_comedone):
  labels.append("acne")
labels.append("acne")
size_close_comedone = len(os.listdir("/content/drive/MyDrive/Comp491 Skincare Project/patch dataset/closed comedone/"))
for i in range(1, size_close_comedone):
  labels.append("acne")
labels.append("acne")
size_pustules = len(os.listdir("/content/drive/MyDrive/Comp491 Skincare Project/patch dataset/pustules/"))
for i in range(1, size_pustules):
  labels.append("acne")
labels.append("acne")
size_cystic = len(os.listdir("/content/drive/MyDrive/Comp491 Skincare Project/patch dataset/cystic/"))
for i in range(1, size_cystic):
  labels.append("acne")
labels.append("acne")

size_no_acne = len(os.listdir("/content/drive/MyDrive/Comp491 Skincare Project/no acne dataset/patches/"))
for i in range(1, size_no_acne):
  labels.append("none")
labels.append("none")



def calculateCooccurrenceMatrix(grayImg, di, dj):
    number_gray_levels = 0
    # finds the number of gray levels present in grayImg
    for (x1, y1), value in np.ndenumerate(grayImg):
        if value > number_gray_levels:
            number_gray_levels = value
    number_gray_levels += 1
    # creates cooccurence matrix having height and width equal to the number of gray levels
    M = np.zeros((number_gray_levels, number_gray_levels))

    # creates cooccurence matrix
    # iterates over each pixel in grayImg
    for (x1, y1), value in np.ndenumerate(grayImg):
        # checks whether the index size is exceeded or not
        if x1 + di >= number_gray_levels or y1 + dj >= number_gray_levels or (x1 + di) >= np.size(grayImg, 0) or (y1 + dj) >= np.size(grayImg, 1):
            continue
        # increases the corresponding value in M according to the coccurence of i and j
        i = grayImg[x1][y1]
        j = grayImg[x1 + di][y1 + dj]
        M[i][j] += 1
    return M

def calculateAccumulatedCooccurrenceMatrix(grayImg, d):
    M1 = calculateCooccurrenceMatrix(grayImg, d, 0)
    M2 = calculateCooccurrenceMatrix(grayImg, d, d)
    M3 = calculateCooccurrenceMatrix(grayImg, 0, d)
    M4 = calculateCooccurrenceMatrix(grayImg, -d, d)
    M5 = calculateCooccurrenceMatrix(grayImg, -d, 0)
    M6 = calculateCooccurrenceMatrix(grayImg, -d, -d)
    M7 = calculateCooccurrenceMatrix(grayImg, 0, -d)
    M8 = calculateCooccurrenceMatrix(grayImg, d, -d)
    accM = M1 + M2 + M3 + M4 + M5 + M6 + M7 + M8
    return accM

def calculateCooccurrenceFeatures(accM):
    # normalization
    sum_M = 0
    for (x1, y1), value in np.ndenumerate(accM):
        sum_M += value
    accM = np.true_divide(accM, sum_M)
    # angular second moment
    angular_second_moment = 0
    # maximum probability
    max_prob = 0
    # inverse difference moment
    inverse_difference_moment = 0
    # contrast
    contrast = 0
    # entropy
    entropy = 0
    for (i, j), value in np.ndenumerate(accM):
        angular_second_moment += value**2
        if value > max_prob:
            max_prob = value
        inverse_difference_moment += value / (1 + (i - j) * (i - j))
        contrast += (i-j)**2 * value
        if value == 0:
            continue
        entropy += value * log(value)
    entropy = -entropy
    # correlation
    correlation = 0
    mean_i = 0
    mean_j = 0
    sum_i = 0
    sum_j = 0
    std_i = 0
    std_j = 0
    i_array = []
    j_array = []
    total = 0
    for (i, j), value in np.ndenumerate(accM):
        total += i * j * value
    for row in accM:
        i_array.append(sum(row))
        sum_i += sum(row)
    mean_i = sum_i/len(row)
    std_i = stdev(i_array)
    for column in np.transpose(accM):
        j_array.append(sum(column))
        sum_j = sum(column)
    mean_j = sum_j/len(column)
    std_j = stdev(j_array)
    correlation = (total - mean_i*mean_j) / (std_i*std_j)
    features = [angular_second_moment, max_prob, inverse_difference_moment, contrast, entropy, correlation]
    return features



# gets images
with tf.device('/device:GPU:0'):
  images_array = []
  for patch in os.listdir("/content/drive/My Drive/Comp491 Skincare Project/patch dataset/open comedone"):
    patchImage = "/content/drive/MyDrive/Comp491 Skincare Project/patch dataset/open comedone/" + str(patch)
    patchImage = cv2.imread(patchImage)
    grayImg = cv2.cvtColor(patchImage, cv2.COLOR_BGR2GRAY)
    images_array.append(grayImg)

  for patch in os.listdir("/content/drive/My Drive/Comp491 Skincare Project/patch dataset/closed comedone"):
    patchImage = "/content/drive/MyDrive/Comp491 Skincare Project/patch dataset/closed comedone/" + str(patch)
    patchImage = cv2.imread(patchImage)
    grayImg = cv2.cvtColor(patchImage, cv2.COLOR_BGR2GRAY)
    images_array.append(grayImg)

  for patch in os.listdir("/content/drive/My Drive/Comp491 Skincare Project/patch dataset/pustules"):
    patchImage = "/content/drive/MyDrive/Comp491 Skincare Project/patch dataset/pustules/" + str(patch)
    patchImage = cv2.imread(patchImage)
    grayImg = cv2.cvtColor(patchImage, cv2.COLOR_BGR2GRAY)
    images_array.append(grayImg)

  for patch in os.listdir("/content/drive/My Drive/Comp491 Skincare Project/patch dataset/cystic"):
    patchImage = "/content/drive/MyDrive/Comp491 Skincare Project/patch dataset/cystic/" + str(patch)
    patchImage = cv2.imread(patchImage)
    grayImg = cv2.cvtColor(patchImage, cv2.COLOR_BGR2GRAY)
    images_array.append(grayImg)

  for patch in os.listdir("/content/drive/My Drive/Comp491 Skincare Project/no acne dataset/patches/"):
    patchImage = "/content/drive/MyDrive/Comp491 Skincare Project/no acne dataset/patches/" + str(patch)
    patchImage = cv2.imread(patchImage)
    grayImg = cv2.cvtColor(patchImage, cv2.COLOR_BGR2GRAY)
    images_array.append(grayImg)

with tf.device('/device:GPU:0'):
  # train-test split
  x_train, x_test, y_train, y_test = train_test_split(images_array, labels, random_state = 4, stratify = labels)

  # feature extraction training
  feature_array_training = []
  for image in x_train:
    accM = calculateAccumulatedCooccurrenceMatrix(image, 5)
    features = calculateCooccurrenceFeatures(accM)
    feature_array_training.append(features)

  # feature extraction test
  feature_array_test = []
  for image in x_test:
    accM = calculateAccumulatedCooccurrenceMatrix(image, 5)
    features = calculateCooccurrenceFeatures(accM)
    feature_array_test.append(features)

# feature normalization for training
from statistics import stdev, mean
means = []
stdevs = []
for column in np.transpose(feature_array_training):
    means.append(mean(column))
    stdevs.append(stdev(column))
for (i, j), value in np.ndenumerate(feature_array_training):
    feature_array_training[i][j] = (value - means[j]) / stdevs[j]

from sklearn import svm
from sklearn.metrics import accuracy_score, confusion_matrix


# SVM with linear kernel
model_linear = svm.SVC(C=5, kernel='linear')
model_linear.fit(feature_array_training, y_train)
pred_linear = model_linear.predict(feature_array_training)
print("overall training accuracy for SVM with linear kernel:")
print(accuracy_score(y_train, pred_linear))
confusion_matrix_linear = confusion_matrix(y_train, pred_linear)
print("class training accuracies for SVM with linear kernel:")
print(confusion_matrix_linear.diagonal()/confusion_matrix_linear.sum(axis=1))

from sklearn.metrics import accuracy_score, confusion_matrix
# SVM with rbf kernel
model_rbf = svm.SVC(C=1000, gamma=0.3, kernel='rbf')
model_rbf.fit(feature_array_training, y_train)
pred_rbf = model_rbf.predict(feature_array_training)
print("overall training accuracy for SVM with rbf kernel:")
print(accuracy_score(y_train, pred_rbf))
confusion_matrix_rbf = confusion_matrix(y_train, pred_rbf)
print("class training accuracies for SVM with rbf kernel:")
print(confusion_matrix_rbf.diagonal()/confusion_matrix_rbf.sum(axis=1))

# SVM with sigmoidal kernel
model_sigmoidal = svm.SVC(C=8, gamma=0.01, coef0=0.001, kernel='sigmoid')
model_sigmoidal.fit(feature_array_training, y_train)
pred_sigmoidal = model_sigmoidal.predict(feature_array_training)
print("overall training accuracy for SVM with sigmoidal kernel:")
print(accuracy_score(y_train, pred_sigmoidal))
confusion_matrix_sigmoidal = confusion_matrix(y_train, pred_sigmoidal)
print("class training accuracies for SVM with sigmoidal kernel:")
print(confusion_matrix_sigmoidal.diagonal()/confusion_matrix_sigmoidal.sum(axis=1))


# feature normalization for test set
from statistics import stdev, mean
means = []
stdevs = []
for column in np.transpose(feature_array_test):
    means.append(mean(column))
    stdevs.append(stdev(column))
for (i, j), value in np.ndenumerate(feature_array_test):
    feature_array_test[i][j] = (value - means[j]) / stdevs[j]

# testing the model for SVM linear kernel
pred_linear = model_linear.predict(feature_array_test)
print("overall test accuracy for SVM with linear kernel:")
print(accuracy_score(y_test, pred_linear))
confusion_matrix_linear = confusion_matrix(y_test, pred_linear)
print("class test accuracies for SVM with linear kernel:")
print(confusion_matrix_linear.diagonal()/confusion_matrix_linear.sum(axis=1))

# testing the model for SVM rbf kernel
pred_rbf = model_rbf.predict(feature_array_test)
print("overall test accuracy for SVM with rbf kernel:")
print(accuracy_score(y_test, pred_rbf))
confusion_matrix_rbf = confusion_matrix(y_test, pred_rbf)
print("class test accuracies for SVM with rbf kernel:")
print(confusion_matrix_rbf.diagonal()/confusion_matrix_rbf.sum(axis=1))

# testing the model for SVM sigmoidal kernel
pred_sigmoidal = model_sigmoidal.predict(feature_array_test)
print("overall test accuracy for SVM with sigmoidal kernel:")
print(accuracy_score(y_test, pred_sigmoidal))
confusion_matrix_sigmoidal = confusion_matrix(y_test, pred_sigmoidal)
print("class test accuracies for SVM with sigmoidal kernel:")
print(confusion_matrix_sigmoidal.diagonal()/confusion_matrix_sigmoidal.sum(axis=1))

