import pickle
import numpy as np
from statistics import stdev, mean
import cv2
from math import log

def predict(image):
    patchImage = cv2.imread(image)
    image = cv2.cvtColor(patchImage, cv2.COLOR_BGR2GRAY)
    loadedModel = pickle.load(open('savedModelAcneType.sav', 'rb'))

    # feature extraction
    feature_array_test = []
    accM = calculateAccumulatedCooccurrenceMatrix(image, 5)
    features = calculateCooccurrenceFeatures(accM)
    feature_array_test.append(features)

    # feature normalization
    means = [0.0008290650033141903, 0.002853211480749235, 0.09797111036835388, 331.6140069503819, 7.723576243018051,
     293474870.899069]
    stdevs = [0.0009626904620228103, 0.005282002740976935, 0.04046373517491762, 264.31481061423375, 0.6202515261615632,
     191359289.47360227]

    for (i, j), value in np.ndenumerate(feature_array_test):
        feature_array_test[i][j] = (value - means[j]) / stdevs[j]
    # testing the model for SVM rbf kernel
    pred_linear = loadedModel.predict(feature_array_test)
    print(pred_linear)
    return pred_linear

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

# predict("4.png")

