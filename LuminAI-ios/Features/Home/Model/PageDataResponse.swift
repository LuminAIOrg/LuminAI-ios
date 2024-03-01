//
//  DataPageModel.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 01.03.24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pageDataResponse = try? JSONDecoder().decode(PageDataResponse.self, from: jsonData)

import Foundation

// MARK: - PageDataResponse
struct PageDataResponse: Codable {
    let pageNumber: Int
    let sensors: [Sensor]
}
