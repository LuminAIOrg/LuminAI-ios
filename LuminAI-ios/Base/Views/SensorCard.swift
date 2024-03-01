//
//  SensorCard.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 01.03.24.
//

import Foundation
import SwiftUI


struct SensorCard: View {
    
    let sensorName: String;
    let sensorRoom: String;
    let sensorColor: String;
    
    init(sensorName: String, sensorRoom: String, sensorColor: String) {
        self.sensorName = sensorName
        self.sensorRoom = sensorRoom
        self.sensorColor = sensorColor
    }
    
    var body: some View {
        VStack {
            Text(sensorName);
            Text(sensorRoom);
        }
    }
}
