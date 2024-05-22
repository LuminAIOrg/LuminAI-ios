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

// MARK: - GetTokenData
struct GetTokenData: Encodable {
    var grant_type: String;
    var code: String;
    var redirect_uri: String;
    var client_id: String;
    var client_secret: String;
}

// MARK: - TokenData

struct TokenData: Codable {
    var accessToken: String
    var expiresIn, refreshExpiresIn: Int
    var refreshToken, tokenType, idToken: String
    var notBeforePolicy: Int
    var sessionState, scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshExpiresIn = "refresh_expires_in"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case idToken = "id_token"
        case notBeforePolicy = "not-before-policy"
        case sessionState = "session_state"
        case scope
    }
}

// MARK: - IntrospectionResponse

struct IntrospectionResponse: Codable {
    let exp, iat, authTime: Int?
    let jti: String?
    let iss: String?
    let aud, sub, typ, azp: String?
    let sessionState, acr: String?
    let allowedOrigins: [String]?
    let realmAccess: RealmAccess?
    let resourceAccess: ResourceAccess?
    let scope, sid: String?
    let emailVerified: Bool?
    let name, preferredUsername, givenName, familyName: String?
    let email, clientID, username, tokenType: String?
    let active: Bool

    enum CodingKeys: String, CodingKey {
        case exp, iat
        case authTime = "auth_time"
        case jti, iss, aud, sub, typ, azp
        case sessionState = "session_state"
        case acr
        case allowedOrigins = "allowed-origins"
        case realmAccess = "realm_access"
        case resourceAccess = "resource_access"
        case scope, sid
        case emailVerified = "email_verified"
        case name
        case preferredUsername = "preferred_username"
        case givenName = "given_name"
        case familyName = "family_name"
        case email
        case clientID = "client_id"
        case username
        case tokenType = "token_type"
        case active
    }
}

// MARK: - RealmAccess
struct RealmAccess: Codable {
    let roles: [String]
}

// MARK: - ResourceAccess
struct ResourceAccess: Codable {
    let account: RealmAccess
}


// MARK: - LatestUsed
struct LatestUsedSensor: Codable, Identifiable {
    let id: Int
    let userID: String
    let sensor: Sensor
    let latestUse: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case sensor, latestUse
    }
}
