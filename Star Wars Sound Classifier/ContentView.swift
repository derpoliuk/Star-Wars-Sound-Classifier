//
//  ContentView.swift
//  Star Wars Sound Classifier
//
//  Created by Stanislav Derpoliuk on 2023-08-04.
//

import SwiftUI

struct ContentView: View {
    @State fileprivate var isListening = false

    @StateObject private var analyzer = Analyzer()

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(isListening ? "\(analyzer.confidenceResult.r2d2)" : "---")
                    Text("R2D2 🤖")
                        .font(.system(size: 16))
                }
                .padding()
                VStack {
                    Text(isListening ? "\(analyzer.confidenceResult.lightsaber)" : "---")
                    Text("Lightsaber ⚔️")
                        .font(.system(size: 16))
                }

                VStack {
                    Text(isListening ? "\(analyzer.confidenceResult.everythingElse)" : "---")
                    Text("Everything else")
                        .font(.system(size: 16))
                }
            }
            .padding()

            Button {
                toggleListening()
            } label: {
                let imageName = isListening ? "stop" : "play.rectangle"
                let color: Color = isListening ? .red : .blue
                Image(systemName: imageName)
                    .font(.system(size: 20))
                    .foregroundStyle(color)
            }
        }
    }

    private func toggleListening() {
        if !isListening {
            startListening()
        } else {
            stopListening()
        }
    }

    private func startListening() {
        guard !isListening else { return }
        if analyzer.start() {
            isListening = true
        }
    }

    private func stopListening() {
        guard isListening else { return }
        defer { isListening = false }
        analyzer.stop()
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
