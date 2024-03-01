//
//  Models.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 01.03.24.
//

import Foundation

// MARK: - Sensor
struct Sensor: Codable {
    let id: Int
    let name: String
    let unit: String?
    let data: [Data]
}

// MARK: - Data
struct Data: Codable {
    let timestamp: Int
    let value: Double
}
