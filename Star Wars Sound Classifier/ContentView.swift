//
//  ContentView.swift
//  Star Wars Sound Classifier
//
//  Created by Stanislav Derpoliuk on 2023-08-04.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var analyzer = Analyzer()

    var body: some View {
        VStack {
            generateMeterViews()
            generateButton()
        }
    }

    private func generateMeterViews() -> some View {
        HStack {
            VStack {
                generateMeter(confidence: analyzer.isAnalyzing ? analyzer.confidenceResult.r2d2 : 0)
                Image("icon-r2d2")
                    .foregroundColor(analyzer.confidenceResult.r2d2 > 0.67 ? .blue : .black)
            }
            .padding()
            VStack {
                generateMeter(confidence: analyzer.isAnalyzing ? analyzer.confidenceResult.lightsaber : 0)
                Image("icon-lightsaber")
                    .foregroundColor(analyzer.confidenceResult.lightsaber > 0.67 ? .red : .black)
            }
        }
        .padding()
    }

    private func generateMeter(confidence: Double) -> some View {
        let numBars = 40
        let barColors = generateConfidenceMeterBarColors(numBars: numBars)
        let confidencePerBar = 1.0 / Double(numBars)
        let barSpacing = CGFloat(2.0)
        let barDimensions = (CGFloat(15.0), CGFloat(2.0))
        let numLitBars = Int(confidence / confidencePerBar)
        let litBarOpacities = [Double](repeating: 1.0, count: numLitBars)
        let unlitBarOpacities = [Double](repeating: 0.1, count: numBars - numLitBars)
        let barOpacities = litBarOpacities + unlitBarOpacities

        return VStack(spacing: barSpacing) {
            ForEach(0..<numBars) {
                Rectangle()
                  .foregroundColor(barColors[numBars - 1 - $0])
                  .opacity(barOpacities[numBars - 1 - $0])
                  .frame(width: barDimensions.0, height: barDimensions.1)
            }
        }.animation(.easeInOut, value: confidence)
    }

    private func generateConfidenceMeterBarColors(numBars: Int) -> [Color] {
        let numGreenBars = Int(Double(numBars) / 3.0)
        let numYellowBars = Int(Double(numBars) * 2 / 3.0) - numGreenBars
        let numRedBars = Int(numBars - numYellowBars)

        return [Color](repeating: .green, count: numGreenBars) +
          [Color](repeating: .yellow, count: numYellowBars) +
          [Color](repeating: .red, count: numRedBars)
    }

    private func generateButton() -> some View {
        Button {
            analyzer.toggleAnalyzing()
        } label: {
            let imageName = analyzer.isAnalyzing ? "stop" : "play.rectangle"
            let color: Color = analyzer.isAnalyzing ? .red : .blue
            Image(systemName: imageName)
                .font(.system(size: 20))
                .foregroundStyle(color)
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
