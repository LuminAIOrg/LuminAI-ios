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
    
    var navigationColor: Color = Theme.Accents.violet;
    
    
    init() {
        
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Symbols.wave
                    .foregroundColor(navigationColor)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 400)
                
                ScrollView {
                    VStack {
                        HomeBigChartView(viewModel: viewModel)
                            .padding(EdgeInsets(top: 50, leading: 20, bottom: 40, trailing: 20))
                            .cardBackground()
                            .padding(15)
                                
                            
                        HomeLatestSensorsView(viewModel:viewModel)
                            
                        HomeMostHappeningView(viewModel: viewModel)
                    }
                }
                .navigationTitle("Overview")
                    
                .toolbarBackground(navigationColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                    
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                                
                        } label: {
                            Symbols.calendar
                                .font(
                                    .system(.headline, design:
                                            .rounded)
                                .bold()
                            )
                        }
                            
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
