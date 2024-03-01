//
//  HomeView.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 01.03.24.
//

import SwiftUI

struct HomeView: View {
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background
                    .ignoresSafeArea(edges: .top)
                // TODO: Chart Overview
                
                // TODO: Latest Use
                
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
