//
//  SensorViewModel.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 22.05.24.
//

import Foundation

class SensorViewModel: ObservableObject {
    
    @Published var sensor: Sensor?;
    
    func clicked(sensorId: Int) {
        Task {
            do {
               
                let latestUsedSensor: LatestUsedSensor = try await WebService.shared.postWithTokenWithoutData(toURL: "/api/latest-use/use/\(sensorId)");
                    
                print("Received Sensor:")
                print(latestUsedSensor)
                    
                DispatchQueue.main.async {
                    self.sensor = latestUsedSensor.sensor
                }
                
                
            } catch {
                print("error: \(error)")
            }
        }
    }
}
