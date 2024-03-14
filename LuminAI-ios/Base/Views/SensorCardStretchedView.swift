//
//  SensorCardStretchedView.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 12.03.24.
//

import Foundation
import SwiftUI
import Charts

// view modifier
struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Theme.cardBackground)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 4, y: 3)
    }
}

extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
    }
}

struct SensorCardStretchedView: View {
    
    let sensor: Sensor;
    
    init(sensor: Sensor) {
        self.sensor = sensor
    }
    
    var body: some View {
        HStack {
            Text("\(sensor.name)")
            Spacer()
            Chart(sensor.data) {
                LineMark(x: .value("Timestamp", Date(timeIntervalSince1970: Double($0.timestamp))), y: .value("Value", $0.value))
                    .interpolationMethod(.monotone)
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .padding()
            .frame(width: 150)
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .cornerRadius(15)
        .cardBackground()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Theme.border, lineWidth: 1)
        )
    }
}


#Preview {
    SensorCardStretchedView(sensor: Sensor(id: 1, name: "<name>", unit: "Deg", color: "#bf81ed", data: [
        Data(timestamp: 1707390664, value: 10),
        Data(timestamp: 1707390670, value: 16),
        Data(timestamp: 1707390676, value: 200),
        Data(timestamp: 1707390682, value: 100),
        Data(timestamp: 1707390688, value: 23)
    ]))
}
