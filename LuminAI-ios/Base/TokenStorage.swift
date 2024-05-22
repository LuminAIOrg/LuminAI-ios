//
//  TokenStorage.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 25.04.24.
//

import Foundation
import KeychainSwift

/*
 * A helper class to deal with token storage and the keychain
 */
class TokenStorage {
    
    static let shared = TokenStorage();
    
    private let keychain = KeychainSwift()
    
    private let storageKey = "at.htl-leonding.LuminAI-ios.tokens"
    
    private init() {
        
    }

    private var tokenData: TokenData?
    
    
    
    /*
     * Try to load token data from storage on application startup
     */
    func loadTokens() {
        if let rawData = keychain.get(self.storageKey) {
            let data = rawData.data(using: .utf8);
            self.tokenData = try? JSONDecoder().decode(TokenData.self, from: data!)
        }
    }

    /*
     * Get tokens if the user has logged in or they have been loaded from storage
     */
    func getTokens() -> TokenData? {
        return self.tokenData
    }

    /*
     * Save tokens to the keychain, where they are encrypted and private to this app
     */
    func saveTokens(newTokenData: TokenData) {
        self.tokenData = newTokenData
        self.saveTokenData()
    }

    /*
     * Remove tokens when we logout or the refresh token expires
     */
    func removeTokens() {
        self.tokenData = nil
        keychain.set("", forKey: self.storageKey)
    }

    /*
     * A hacky method for testing, to update token storage to make the access token act like it is expired
     */
    func expireAccessToken() {

        if self.tokenData != nil {
            self.tokenData!.accessToken = "\(self.tokenData!.accessToken)x"
            self.saveTokenData()
        }
    }

    /*
     * A hacky method for testing, to update token storage to make the refresh token act like it is expired
     */
    func expireRefreshToken() {

        if self.tokenData != nil {
            self.tokenData!.accessToken = "\(self.tokenData!.accessToken)x"
            self.tokenData!.refreshToken = "\(self.tokenData!.refreshToken)x"
            self.saveTokenData()
        }
    }

    /*
     * Load token data from storage
     */
    private func saveTokenData() {

        let encoder = JSONEncoder()
        let jsonText = try? encoder.encode(self.tokenData)
        if jsonText != nil {
            keychain.set(jsonText!, forKey: self.storageKey)
        }
    }
}
