//
//  HomeBigChartView.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 13.03.24.
//

import Foundation
import SwiftUI
import Charts

struct HomeBigChartView: View {
    
    @ObservedObject var viewModel: HomeViewModel;
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if let data = viewModel.chartData {
            Chart(data) {
                LineMark(
                    x: .value("Timestamp", Date(timeIntervalSince1970: Double($0.timestamp))),
                    y: .value("Value", $0.value)
                )
                .interpolationMethod(.monotone)
            }
        } else {
            ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle())
        }
    }
}
