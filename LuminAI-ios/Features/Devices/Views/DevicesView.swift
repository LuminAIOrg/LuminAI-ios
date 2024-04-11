//
//  DevicesView.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 13.03.24.
//

import SwiftUI

struct DevicesView: View {
    
    @StateObject var viewModel = DevicesViewModel();
    
    
    var navigationColor: Color = Theme.Accents.blue;
    
    var body: some View {
        NavigationView {
            ZStack {
                Symbols.wave
                    .foregroundColor(navigationColor)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 400)
                VStack {
                    
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
