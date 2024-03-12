//
//  HomeViewModel.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 12.03.24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var chartData: [Data]?;
    @Published var latestUse: [Sensor]?;
    @Published var mostHappening: [Sensor]?;

    
    init() {
        do {
            self.chartData = try StaticJSONMapper.decode(file: "LatestUseStatic", type: LatestUseResponse.self).first?.data ?? [];
            self.latestUse = try StaticJSONMapper.decode(file: "LatestUseStatic", type: LatestUseResponse.self);
            self.mostHappening = try StaticJSONMapper.decode(file: "MostHappeningAsc", type: LatestUseResponse.self);
        } catch {
            print("Something went wrong")
        }
    }
    
    func changeMostHappeningSort(sorting: SortBy) {
        do {
            if(sorting == SortBy.ASC) {
                self.mostHappening = try StaticJSONMapper.decode(file: "MostHappeningAsc", type: LatestUseResponse.self);
            } else if (sorting == SortBy.DESC) {
                self.mostHappening = try StaticJSONMapper.decode(file: "MostHappeningDesc", type: LatestUseResponse.self);
            }
        } catch {
            print("Something went wrong")
        }
        
    }
}

enum SortBy: String, CaseIterable, Identifiable {
    case ASC
    case DESC
    public var id: Self {
        return self
    }
    
    var title: String {
            switch self {
                case .ASC:
                    return "Ascending"
                case .DESC:
                    return "Descending"
            }
        }
}
