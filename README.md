Codes submission to the OMG EmotionChallenge https://github.com/knowledgetechnologyuhh/OMGEmotionChallenge.

Short description of the method:

The architecture contains two step. In the first step, we use the Facial Action Coding System (FACS), a fully standardized classification system that codes facial expressions based on anatomic features of human faces. With the FACS, any facial expression can be decomposed as a combination of elementary components called Action Units (AUs). In particular, we use the automated software Emotient FACET, a computer vision program which provides frame-based estimates of the likelihood of 20 AUs. In the second step, we leverage an Echo State Network, a variant of Recurrent Neural Network, to learn the coherence between facial expression and valence-arousal values. The hyper parameters of the network is tuned based on 5-fold cross validation.


Environment:

1. MATLAB®
2. MATLAB® Financial Toolbox https://www.mathworks.com/products/finance.html


Usage: 

1. Run omg_loadSensorData_test.m to load the sensor data for training.
2. Run challenge_main.m to get the prediction result stored in predictionOnTestingData.csv

(Note: you need to change the directory for the .csv files in the codes.)

