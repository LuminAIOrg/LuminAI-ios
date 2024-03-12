//
//  HomeView.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 01.03.24.
//

import SwiftUI
import Charts

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    @State var sortPopoverShow = false;
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background
                    .ignoresSafeArea(edges: .top)
                // TODO: Chart Overview
                VStack {
                    
                    if let data = viewModel.chartData {
                        Chart(data) {
                            LineMark(
                                x: .value("Timestamp", Date(timeIntervalSince1970: Double($0.timestamp))),
                                y: .value("Value", $0.value)
                            )
                        }
                    } else {
                        ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle())
                    }
     
                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            if let sensorData = viewModel.latestUse {
                                ForEach(sensorData) { sensor in
                                    SensorCardView(sensorName: "\(sensor.name)", sensorRoom: "Room x", sensorColor: generateRandomPastelColor())
                                }
                            } else {
                                ProgressView("Loading...")
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                        }.padding()
                    }
                    
                    if let data = viewModel.mostHappening {
                        // TODO: implement sorting
                        VStack{
                            List(data) { sensor in
                                Text("\(sensor.name)")
                            }
                        }
                    }
                }
                
                
                // TODO: Most Happening
            }
            .navigationTitle("Overview")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        
                    } label: {
                        Symbols.calendar
                            .font(
                                .system(.headline, design: .rounded)
                                .bold()
                            )
                    }

                }
            }
        }
    }
}

#Preview {
    HomeView()
}
