//
//  SensorViewModel.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 22.05.24.
//

import Foundation

class SensorViewModel: ObservableObject {
    
    @Published var sensor: Sensor?;
    
    func clicked() {
        Task {
            do {
                if let sensorId = sensor?.id {
                    let sensor: LatestUsedSensor = try await WebService.shared.postWithTokenWithoutData(toURL: "/api/latest-use/use/\(sensorId)");
                    
                    print("Received Sensor:")
                    print(sensor)
                }
                
                
            } catch {
                print("error: \(error)")
            }
        }
    }
}
