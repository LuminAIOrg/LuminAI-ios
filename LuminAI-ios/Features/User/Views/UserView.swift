//
//  UserView.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 13.03.24.
//

import SwiftUI

struct UserView: View {
    
    var navigationColor: Color = Theme.Accents.orange;
    
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
            .navigationTitle("Profile")
            .toolbarBackground(navigationColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    UserView()
}
