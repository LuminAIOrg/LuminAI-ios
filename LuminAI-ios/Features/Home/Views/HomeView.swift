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
    
    @ObservedObject var appAuth: AppAuthHandler;
    

    
    var body: some View {
        NavigationView {
            ZStack {
                Symbols.wave
                    .foregroundColor(navigationColor)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 400)
                
                if(appAuth.isAuthenticated) {
                    ScrollView {
                        VStack {
                            HomeBigChartView(viewModel: viewModel)
                                .padding(EdgeInsets(top: 50, leading: 20, bottom: 40, trailing: 20))
                                .cardBackground()
                                .padding(15)
                                    
                            Text("Latest Use")
                                .font(.title)
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HomeLatestSensorsView(viewModel:viewModel)
                            
                            Text("Most Happening")
                                .font(.title)
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            HomeMostHappeningView(viewModel: viewModel)
                        }
                    }
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
                    .onAppear {
                        Task {
                            await viewModel.fetchPagedSensors()
                        }
                    }
                    
                } else {
                    Text("UnAuthenticated")
                }
            }
            .navigationTitle("Overview")
            .toolbarBackground(navigationColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
        }
    }
}

#Preview {
    HomeView(appAuth: AppAuthHandler(config: try! ApplicationConfigLoader.load()))
}

