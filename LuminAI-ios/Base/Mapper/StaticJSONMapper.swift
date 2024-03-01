//
//  StaticJSONMapper.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 01.03.24.
//

import Foundation

struct StaticJSONMapper {
    static func decode<T: Decodable>(file: String, type: T.Type) throws -> T {
        guard let path = Bundle.main.path(forResource: file, ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            throw MappingError.failedToGetContents
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension StaticJSONMapper {
    enum MappingError: Error {
        case failedToGetContents
    }
}
