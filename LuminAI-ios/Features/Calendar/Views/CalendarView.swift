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
    
    @StateObject var viewModel = CalendarViewModel();
    
    let dateFormatter: DateFormatter;
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                Symbols.wave
                    .foregroundColor(navigationColor)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 600)
                VStack {
                    HStack{
                        Button(action: {
                            viewModel.monthBack()
                        }) {
                            Symbols.backArrow
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Text("\(DateFormatter().monthSymbols[(viewModel.month + 0) % 12])")
                                .bold()
                            
                            HStack(alignment: .center) {
                                //Text("\(DateFormatter().monthSymbols[(viewModel.month + 10) % 12])")
                                Text("\(DateFormatter().monthSymbols[(viewModel.month + 11) % 12])")
                                
                                Spacer()
                                
                                Text("\(DateFormatter().monthSymbols[(viewModel.month + 1) % 12])")
                                //Text("\(DateFormatter().monthSymbols[(viewModel.month + 2) % 12])")
                            }
                        }

                        Spacer()
                        
                        Button(action: {
                            viewModel.monthForward()
                        }) {
                            Symbols.forwardArrow
                        }
                    }.padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    
                    HStack {
                        Button(action: {
                            viewModel.yearBack()
                        }) {
                            Symbols.backArrow
                        }
                        
                        Spacer();
                        
                        Text("\(viewModel.getFormattedYear(year: viewModel.year))")
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.yearForward()
                        }) {
                            Symbols.forwardArrow
                        }
                    }.padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    
                    
                    
            
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
