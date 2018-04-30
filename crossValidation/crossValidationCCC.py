from __future__ import print_function
import argparse
import os
import csv
import sys


from scipy.stats import pearsonr
import numpy
import pandas


def ccc(y_true, y_pred):
    true_mean = numpy.mean(y_true)
    true_variance = numpy.var(y_true)
    pred_mean = numpy.mean(y_pred)
    pred_variance = numpy.var(y_pred)

    rho,_ = pearsonr(y_pred,y_true)

    std_predictions = numpy.std(y_pred)

    std_gt = numpy.std(y_true)


    ccc = 2 * rho * std_gt * std_predictions / (
        std_predictions ** 2 + std_gt ** 2 +
        (pred_mean - true_mean) ** 2)

    return ccc, rho



def calculateCCC(validationFile, modelOutputFile):


    dataY = pandas.read_csv(validationFile, header=0, sep=",")

    dataYPred = pandas.read_csv(modelOutputFile, header=0, sep=",")

    dataYArousal = dataY["arousal"]
    dataYValence = dataY["valence"]
    dataYPredArousal = dataYPred["arousal"]
    dataYPredValence = dataYPred["valence"]

    arousalCCC, acor = ccc(dataYArousal, dataYPredArousal)
    valenceCCC, vcor = ccc(dataYValence, dataYPredValence)

    # print ("Arousal CCC: ", arousalCCC)
    # print ("Valence CCC: ", valenceCCC)

    return arousalCCC, valenceCCC



validationGT1 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate1/omg_cv_Validation1.csv';
validationGT2 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate2/omg_cv_Validation2.csv';
validationGT3 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate3/omg_cv_Validation3.csv';
validationGT4 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate4/omg_cv_Validation4.csv';
validationGT5 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate5/omg_cv_Validation5.csv';





prediction1 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate1/prediction1.csv';
prediction2 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate2/prediction2.csv';
prediction3 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate3/prediction3.csv';
prediction4 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate4/prediction4.csv';
prediction5 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate5/prediction5.csv';



validationFiles = [validationGT1, validationGT2, validationGT3, validationGT4, validationGT5]
predictions     = [prediction1,   prediction2,   prediction3,    prediction4, prediction5]

totalArousalCCC = 0
totalValenceCCC = 0


for i in range(5):
    validationFile = validationFiles[i]
    prediction = predictions[i]
    arousalCCC, valenceCCC = calculateCCC(validationFile, prediction)
    print(arousalCCC, valenceCCC)
    totalArousalCCC += arousalCCC
    totalValenceCCC += valenceCCC


averagedArousalCCC =  totalArousalCCC/5
averagedValenceCCC = totalValenceCCC/5


print ("Arousal CCC: ", averagedArousalCCC)
print ("Valence CCC: ", averagedValenceCCC)









