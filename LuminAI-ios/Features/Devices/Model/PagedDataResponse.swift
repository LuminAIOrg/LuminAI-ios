//
//  PagedDataResponse.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 23.05.24.
//

import Foundation

struct PagedDataResponse: Codable {
    let pageNumber: Int
    let sensors: [Sensor]
}
