# Music-Player-Based-On-Age-Classification

### For MATLAB Version 2017b 

## Dataset

Dataset comprises of face-images of 100,000 celebrities taken from IMDB
and Wikipedia.
Data set was divided into two parts -
1. Training Data set (1000 images) (training - Copy.xlsx)
2. Testing Data Set

Source: https://data.vision.ee.ethz.ch/cvl/rrothe/imdb-wiki/

## Description

**There exists a Camera.m file which serves as the Master Script. It:**
- Opens the built-windows Camera
- Captures the image
- Calls detection function. (Captured image sent as an argument)

**There are separate m- Scripts for each function that is called.**

# Functions called:

- detection: Detects the face in the image captured. Displays error message if face not detected or multiple faces detected. Uses Canny Edge Detection for face detection and Viola - Jones Algorithm for feature extraction. Features extracted: Nose, Mouth, Eyes.
- ratios: Calculates six types of ratios to distinguish between baby faces from other two older groups - young and old.
- wrinkles: Wrinkle analysis targetting five regions - forehead, under the eyes, and cheek region.
- classifier: Loads training data set and calls multiclassify.
- multiclassify: Support Vector Machine alogrithm used to perform classification of image captured.
- mapping_age: Maps age group predicted to respective songs.
- audio_player: Plays songs from the generated playlist. User cans play, stop, pause and choose songs.
