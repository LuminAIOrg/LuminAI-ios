//
//  SensorCard.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 01.03.24.
//

import Foundation
import SwiftUI


struct SensorCardView: View {
    
    let sensorName: String;
    let sensorRoom: String;
    let sensorColor: Color;
    
    init(sensorName: String, sensorRoom: String, sensorColor: Color) {
        self.sensorName = sensorName
        self.sensorRoom = sensorRoom
        self.sensorColor = sensorColor
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .fill(sensorColor)
                
            VStack {
                Text(sensorName)
                    .bold()
                    .font(.system(size: 20))
                Text(sensorRoom);
            }
            .padding(.horizontal)
            Spacer()
        }
        .background(Theme.cardBackground)
        .frame(width: 150, height: 160, alignment: .leading)
        .cornerRadius(8.0)
        .shadow(radius: 3, y: 2)
    }
}


#Preview {
    SensorCardView(sensorName: "<Name>", sensorRoom: "<Room>", sensorColor: generateRandomPastelColor())
}
