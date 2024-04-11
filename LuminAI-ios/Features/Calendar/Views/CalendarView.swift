//
//  CalendarView.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 02.04.24.
//

import SwiftUI

enum Month: String {
    case january = "Januar"
    case february = "Februar"
    case march = "März"
    case april = "April"
    case may = "Mai"
    case june = "Juni"
    case july = "Juli"
    case august = "August"
    case september = "September"
    case october = "Oktober"
    case november = "November"
    case december = "Dezember"
    
    
}


struct CalendarView: View {
    
    var navigationColor: Color = Theme.Accents.blue;

    
    var body: some View {
        ScrollView {
            ZStack {
                Symbols.wave
                    .foregroundColor(navigationColor)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 600)
                VStack {
                    
                    
                    
            
                }
            }
        }
        .navigationTitle("Monthly Overview")
        .toolbarBackground(navigationColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    CalendarView()
}
