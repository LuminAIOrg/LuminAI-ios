//
//  ApplicationConfigLoader.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 25.04.24.
//


import Foundation

struct ApplicationConfigLoader {

    static func load() throws -> ApplicationConfig {

        let configFilePath = Bundle.main.path(forResource: "config", ofType: "json")
        let jsonText = try String(contentsOfFile: configFilePath!)
        let jsonData = jsonText.data(using: .utf8)!
        let decoder = JSONDecoder()

        let data =  try decoder.decode(ApplicationConfig.self, from: jsonData)
        return data
    }
}
