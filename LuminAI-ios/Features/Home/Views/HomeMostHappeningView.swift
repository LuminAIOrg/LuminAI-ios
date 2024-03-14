//
//  HomeMostHappeningView.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 13.03.24.
//

import Foundation
import SwiftUI

struct HomeMostHappeningView: View {
    
    @ObservedObject var viewModel: HomeViewModel;
    
    @State var sortOption: SortBy = .DESC
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if viewModel.mostHappening != nil {
                Picker("Hello world", selection: Binding(get: {
                    return sortOption
                }, set: {
                    viewModel.changeMostHappeningSort(sorting: $0)
                    sortOption = $0
                })) {
                    ForEach(SortBy.allCases) {
                        Text("\($0.title)").tag($0)
                    }
                }.pickerStyle(.segmented)
                ForEach(viewModel.mostHappening!) { sensor in
                    NavigationLink(destination: SensorView(sensor: sensor)) {
                        SensorCardStretchedView(sensor: sensor)
                    }
                }
                
            } else {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }.padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
}

#Preview {
    HomeMostHappeningView(viewModel: HomeViewModel())
}
