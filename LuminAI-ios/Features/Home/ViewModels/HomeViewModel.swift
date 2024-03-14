//
//  HomeViewModel.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 12.03.24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var chartData: [Data]?;

    
    init() {
        do {
            self.chartData = try StaticJSONMapper.decode(file: "MostHappeningDesc", type: LatestUseResponse.self).first?.data ?? [];
            
        } catch {
            print("Something went wrong")
        }
    }
}
