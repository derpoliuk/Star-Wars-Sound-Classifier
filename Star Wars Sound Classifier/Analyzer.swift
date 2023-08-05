//
//  Analyzer.swift
//  Star Wars Sound Classifier
//
//  Created by Stanislav Derpoliuk on 2023-08-05.
//

import AVFoundation
import CreateMLComponents
import Dispatch
import Foundation
import SoundAnalysis

final class Analyzer: NSObject, ObservableObject {
    struct ConfidenceResult {
        let r2d2: Double
        let lightsaber: Double
        let everythingElse: Double
    }

    @Published private(set) var confidenceResult: ConfidenceResult = ConfidenceResult(r2d2: 0, lightsaber: 0, everythingElse: 0)

    private enum AnalyzerError: Error {
        case noMicrophoneAccess
    }

    private var audioEngine: AVAudioEngine?
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    private let analysisQueue = DispatchQueue.global()

    func start() -> Bool {
        do {
            try ensureMicrophoneAccess()
        } catch {
            print("Unable to get access to mic: \(error.localizedDescription)")
        }

        let audioEngine = AVAudioEngine()

        let inputBus = AVAudioNodeBus(0)
        let inputFormat = audioEngine.inputNode.inputFormat(forBus: inputBus)

        do {
            try audioEngine.start()
        } catch {
            print("Unable to start AVAudioEngine: \(error.localizedDescription)")
            return false
        }

        let streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
        let request: SNClassifySoundRequest
        do {
            request = try SNClassifySoundRequest(mlModel: StarWarsSoundClassifier_v1().model)
        } catch {
            print("Unable to create SNClassifySoundRequest: \(error.localizedDescription)")
            audioEngine.stop()
            return false
        }

        do {
            try streamAnalyzer.add(request, withObserver: self)
        } catch {
            print("Unable to add request to SNAudioStreamAnalyzer: \(error.localizedDescription)")
            audioEngine.stop()
            return false
        }

        self.streamAnalyzer = streamAnalyzer
        self.audioEngine = audioEngine

        audioEngine.inputNode.installTap(
            onBus: inputBus, bufferSize: 8192,
            format: inputFormat,
            block: analyzeAudio(buffer:at:))


        return true
    }

    private func analyzeAudio(buffer: AVAudioBuffer, at time: AVAudioTime) {
        analysisQueue.async { [weak streamAnalyzer] in
            streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
        }
    }

    func stop() {
        audioEngine?.stop()
        audioEngine = nil
        streamAnalyzer?.removeAllRequests()
        streamAnalyzer = nil
    }


    /// Requests permission to access microphone input, throwing an error if the user denies access.
    private func ensureMicrophoneAccess() throws {
        var hasMicrophoneAccess = false
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .notDetermined:
            let sem = DispatchSemaphore(value: 0)
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { success in
                hasMicrophoneAccess = success
                sem.signal()
            })
            _ = sem.wait(timeout: DispatchTime.distantFuture)
        case .denied, .restricted:
            break
        case .authorized:
            hasMicrophoneAccess = true
        @unknown default:
            fatalError("unknown authorization status for microphone access")
        }

        if !hasMicrophoneAccess {
            throw AnalyzerError.noMicrophoneAccess
        }
    }
}

extension Analyzer: SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let classificationResult = result as? SNClassificationResult else {
            return
        }
        var r2d2 = 0.0
        var lightsaber = 0.0
        var everythingElse = 0.0

        for classification in classificationResult.classifications {
            switch classification.identifier {
            case "R2D2":
                r2d2 = classification.confidence
            case "Lightsaber":
                lightsaber = classification.confidence
            case "Everything Else":
                everythingElse = classification.confidence
            default:
                break
            }
        }

        DispatchQueue.main.async {
            self.confidenceResult = ConfidenceResult(r2d2: r2d2, lightsaber: lightsaber, everythingElse: everythingElse)
        }
    }
}
