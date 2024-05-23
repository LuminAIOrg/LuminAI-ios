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
//        do {
//            self.sensors = try StaticJSONMapper.decode(file: "MostHappeningDesc", type: [Sensor].self);
//        } catch {
//            print("Something went wrong")
//        }
        Task {
            let sensors = try await getSensors();
            
            DispatchQueue.main.async {
                self.sensors = sensors;
            }
        }
    }
    
    func getSensors() async throws -> [Sensor] {
        let pagedData: PagedDataResponse = try await WebService.shared.fetchWithToken(fromURL: "/api/data/page");
        let sensors = pagedData.sensors;
    
        let sortedSensors = sensors.sorted { $0.name > $1.name }
        
        return sortedSensors;
    }
    
    func changeSort(by sortBy: DevicesSortBy) {
//        do {
//            if(sortBy == DevicesSortBy.ASC) {
//                self.sensors = try StaticJSONMapper.decode(file: "MostHappeningAsc", type: [Sensor].self);
//            } else if (sortBy == DevicesSortBy.DESC) {
//                self.sensors = try StaticJSONMapper.decode(file: "MostHappeningDesc", type: [Sensor].self);
//            }
//        } catch {
//            print("Something went wrong")
//        }
        if sortBy == DevicesSortBy.ASC {
            self.sensors = self.sensors?.sorted { $0.name < $1.name }
           } else if (sortBy == DevicesSortBy.DESC) {
               self.sensors = self.sensors?.sorted { $0.name > $1.name }
           }
    }
}
