//
//  CalendarViewModel.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 02.04.24.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published private(set) var year: Int;
    @Published private(set) var month: Int;
    
   
    init() {
        let currentDate = Date();
        year = Calendar.current.component(.year, from: currentDate)
        month = Calendar.current.component(.month, from: currentDate)
    }
    
    func monthBack() {
        if(month == 1) {
            month = 12;
            year -= 1;
        }
        month -= 1;
    }
    
    func monthForward() {
        if(month == 12) {
            month = 1;
            year += 1;
        }
        month+=1
    }
    
    func yearBack() {
        year -= 1;
    }
    
    func yearForward() {
        year += 1;
    }
    
    func getFormattedYear(year: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: createDate(year: year)!)
    }
        
    private func createDate(year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = 1  // January
        dateComponents.day = 1    // 1st day of the month
        
        return Calendar.current.date(from: dateComponents)
    }
}
