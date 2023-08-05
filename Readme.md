# Star Wars Sound Classifier

This iOS app classifies the lightsaber and R2D2 sounds from Star Wars from the microphone input.

## Purpose

The purpose of creating this project is to learn a Create ML and Sound Analysis framework in practice.

## How to run the app

Because the app uses mic input, it works only on the device. There might be a way to set up the app to work on a Simulator, but it is out of the scope of this project. The main focus is to learn how to use Create ML and Sound Analysis framework in practice.

To run the app:

1. Clone the repo
2. Configure code signing
3. Run the app on the device

After the app is launched, start your favorite Star Wars movie, tap on the Play button, and observe the results:

<img width="200" src="https://github.com/derpoliuk/Star-Wars-Sound-Classifier/assets/1434418/c22b5324-b892-422c-abcc-ce10c9e8f1f3">
<img width="200" src="https://github.com/derpoliuk/Star-Wars-Sound-Classifier/assets/1434418/4ab0231e-be75-45ea-8984-0a1b2cf07da4">
<img width="200" src="https://github.com/derpoliuk/Star-Wars-Sound-Classifier/assets/1434418/ed07adfa-bd94-4045-92e7-098e32d7b5e8">

## Create ML

### Preparing audio sounds

The Core ML model was trained in the Create ML (`Version 5.0 Beta (119)`) using sounds from YouTube videos and from the website [http://www.galaxyfaraway.com](http://www.galaxyfaraway.com).

Sounds were grouped into 3 folders:

<img width="488" alt="Screenshot 2023-08-05 at 11 38 12 AM" src="https://github.com/derpoliuk/Star-Wars-Sound-Classifier/assets/1434418/f4b891e5-2522-4ecb-bbd9-4d5cd17aea03">

We need to provide a variety of different sounds other ones we want to classify (lightsaber and R2D2) to properly train the model.

### Training

The training was performed with default settings:

<img width="1512" alt="Screenshot 2023-08-05 at 11 36 50 AM" src="https://github.com/derpoliuk/Star-Wars-Sound-Classifier/assets/1434418/356514f6-b106-4a9f-8253-01278a0b430a">

## What's left outside of the scope

- The app doesn't work on Simulator
- The app doesn't handle audio interruptions (for example incoming phone calls during sound analysis)

## References

### Technical

- Apple's "Classifying Live Audio Input with a Built-in Sound Classifier" sample project ([link](https://developer.apple.com/documentation/soundanalysis/classifying_live_audio_input_with_a_built-in_sound_classifier)). This project is a great sample on how to detect different sounds using built-in sound classifications. In addition, it has a code to properly handle audio interruptions and a neat SwiftUI meter view that was copied into this project.
- WWDC video "Training Sound Classification Models in Create ML" ([link](https://developer.apple.com/videos/play/wwdc2019/425))
- Apple's article "Classifying Sounds in an Audio Stream" ([link](https://developer.apple.com/documentation/soundanalysis/classifying_sounds_in_an_audio_stream))

### Non-technical

- Sounds for training ML model were downloaded from http://www.galaxyfaraway.com
- R2D2 and lightsaber icons were downloaded from https://icons8.com