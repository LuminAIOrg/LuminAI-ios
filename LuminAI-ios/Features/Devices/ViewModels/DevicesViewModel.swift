//
//  DevicesViewModel.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 13.03.24.
//

import Foundation

class DevicesViewModel: ObservableObject {
    @Published var sensors: [Sensor]?
    
    init() {
        do {
            self.sensors = try StaticJSONMapper.decode(file: "MostHappeningDesc", type: LatestUseResponse.self);
        } catch {
            print("Something went wrong")
        }
    }
    
    func changeSort(by sortBy: DevicesSortBy) {
        do {
            if(sortBy == DevicesSortBy.ASC) {
                self.sensors = try StaticJSONMapper.decode(file: "MostHappeningAsc", type: LatestUseResponse.self);
            } else if (sortBy == DevicesSortBy.DESC) {
                self.sensors = try StaticJSONMapper.decode(file: "MostHappeningDesc", type: LatestUseResponse.self);
            }
        } catch {
            print("Something went wrong")
        }
    }
}
