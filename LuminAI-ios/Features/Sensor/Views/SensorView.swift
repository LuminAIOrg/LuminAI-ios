//
//  SensorView.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 13.03.24.
//

import SwiftUI
import Charts

struct SensorView: View {
    
    var navigationColor: Color = Theme.Accents.red;
    
    @ObservedObject var viewModel = SensorViewModel()
    
    init(sensor: Sensor) {
        viewModel.sensor = sensor;
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                Symbols.wave
                    .foregroundColor(navigationColor)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 600)
                VStack {
                    Chart(viewModel.sensor!.data) {
                        LineMark(x: .value("Timestamp", Date(timeIntervalSince1970: Double($0.timestamp))), y: .value("Value", $0.value))
                            .interpolationMethod(.monotone)
                    }
                    .frame(height: 200)
                    .padding(15)
                }
                .onAppear {
                    viewModel.clicked()
                }
            }
        }
        .navigationTitle(viewModel.sensor!.name)
        .toolbarBackground(navigationColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    SensorView(sensor: Sensor(id: 1, name: "<sensor>", unit: "<unit>", color: "#ff00ff", data: [
        Data(timestamp: 1707390664, value: 10),
        Data(timestamp: 1707390670, value: 16),
        Data(timestamp: 1707390676, value: 200),
        Data(timestamp: 1707390682, value: 100),
        Data(timestamp: 1707390688, value: 23)
    ]))
}
