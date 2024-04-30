//
//  Model.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 27.04.24.
//

import Foundation


struct UserInfo: Codable {
    let userID, username, email: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case username, email
    }
}

