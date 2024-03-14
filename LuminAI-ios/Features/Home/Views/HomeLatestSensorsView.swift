//
//  HomeLatestSensorsView.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 13.03.24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}


struct HomeLatestSensorsView: View {
    
    @ObservedObject var viewModel: HomeViewModel;
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                if let sensorData = viewModel.latestUse {
                    ForEach(sensorData) { sensor in
                        NavigationLink(destination: SensorView(sensor: sensor)) {
                            SensorCardView(sensorName: "\(sensor.name)", sensorRoom: "Room x", sensorColor: Color(hex: sensor.color ?? "#adadad"))
                        }
                    }
                } else {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }.padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
        }
    }
}
