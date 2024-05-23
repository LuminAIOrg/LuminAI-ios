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
    var sensorId: Int;
    var sensorNameTemp: String;
    
    @ObservedObject var viewModel = SensorViewModel()
    
    init(sensorId: Int, sensorNameTemp: String) {
        print("Sensor page init")
        self.sensorId = sensorId;
        self.sensorNameTemp = sensorNameTemp;
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                Symbols.wave
                    .foregroundColor(navigationColor)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 600)
                VStack {
                    if let sensor = viewModel.sensor {
                        Chart(sensor.data) {
                            LineMark(x: .value("Timestamp", Date(timeIntervalSince1970: Double($0.timestamp))), y: .value("Value", $0.value))
                                .interpolationMethod(.monotone)
                        }
                        .frame(height: 200)
                        .padding(15)
                    } else {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    
                    
                }
            }.onAppear {
                viewModel.clicked(sensorId: sensorId)
            }
        }
        .navigationTitle(viewModel.sensor?.name ?? self.sensorNameTemp)
        .toolbarBackground(navigationColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    SensorView(sensorId: 51, sensorNameTemp: "TempName")
}
