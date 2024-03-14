//
//  Models.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 01.03.24.
//

import Foundation

// MARK: - Sensor
struct Sensor: Codable, Identifiable {
    let id: Int
    let name: String
    let unit: String?
    let color: String?
    let data: [Data]
}

// MARK: - Data
struct Data: Codable, Identifiable {
    let timestamp: Int
    let value: Double
    var id: String {
        return "\(timestamp)_\(value)"
    }
}
