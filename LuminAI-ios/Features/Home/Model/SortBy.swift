//
//  SortBy.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 13.03.24.
//

import Foundation

enum SortBy: String, CaseIterable, Identifiable {
    case ASC
    case DESC
    public var id: Self {
        return self
    }
    
    var title: String {
            switch self {
                case .ASC:
                    return "Ascending"
                case .DESC:
                    return "Descending"
            }
        }
}
