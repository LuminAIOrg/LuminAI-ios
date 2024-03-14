//
//  DevicesView.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 13.03.24.
//

import SwiftUI

struct DevicesView: View {
    
    @StateObject var viewModel = DevicesViewModel();
    
    @State var sortOption: DevicesSortBy = .DESC
    
    var navigationColor: Color = Theme.Accents.blue;
    
    var body: some View {
        NavigationView {
            ZStack {
                Symbols.wave
                    .foregroundColor(navigationColor)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 400)
                VStack {
                    Picker("Select", selection: Binding(get: {
                        return sortOption
                    }, set: {
                        viewModel.changeSort(by: $0)
                        sortOption = $0
                    })) {
                        ForEach(DevicesSortBy.allCases) {
                            Text("\($0.title)").tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(14)
                    
                    ScrollView {
                        if let data = viewModel.sensors {
                            ForEach(data) { sensor in
                                NavigationLink(destination: SensorView(sensor: sensor)) {
                                    SensorCardStretchedView(sensor: sensor)
                                        .padding(EdgeInsets(top: 4, leading: 15, bottom: 6, trailing: 15))
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Devices")
            .toolbarBackground(navigationColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    DevicesView()
}
