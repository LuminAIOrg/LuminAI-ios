//
//  HomeViewModel.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 12.03.24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var chartData: [Data]?;
    @Published var latestUse: LatestUsedSensorsResponse?;
    @Published var mostHappening: [Sensor]?;

    
    init() {
        do {
            self.chartData = try StaticJSONMapper.decode(file: "MostHappeningDesc", type: [Sensor].self).first?.data ?? [];
//            self.latestUse = try StaticJSONMapper.decode(file: "LatestUseStatic", type: LatestUseResponse.self);
            self.mostHappening = try StaticJSONMapper.decode(file: "MostHappeningDesc", type:  [Sensor].self);
        } catch {
            print("Something went wrong reading static data")
        }
    }
    
    func fetchPagedSensors() async {
        do {
            let pagedSensors: PageDataResponse = try await WebService.shared.fetchWithToken(fromURL: "/api/data/page");
            
//            print(pagedSensors)
        } catch {
           print(error)
        }
    }
    
    func fetchLatestUsedSensors() async throws -> LatestUsedSensorsResponse {
        return try await WebService.shared.fetchWithToken(fromURL: "/api/latest-use");
    }
    
    func changeMostHappeningSort(sorting: SortBy) {
        do {
            if(sorting == SortBy.ASC) {
                self.mostHappening = try StaticJSONMapper.decode(file: "MostHappeningAsc", type: [Sensor].self);
            } else if (sorting == SortBy.DESC) {
                self.mostHappening = try StaticJSONMapper.decode(file: "MostHappeningDesc", type: [Sensor].self);
            }
        } catch {
            print("Something went wrong")
        }
        
    }
}
