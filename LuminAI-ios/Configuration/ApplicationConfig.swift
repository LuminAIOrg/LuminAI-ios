//
//  ApplicationConfig.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 25.04.24.
//

class ApplicationError: Error {
    
    var title: String
    var description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

import Foundation

struct ApplicationConfig: Decodable {

    let issuer: String
    let clientID: String
    let redirectUri: String
    let postLogoutRedirectUri: String
    let scope: String
    let secret: String;
    
    init() {
        self.issuer = ""
        self.clientID = ""
        self.redirectUri = ""
        self.postLogoutRedirectUri = ""
        self.scope = ""
        self.secret = ""
    }
    
    func getIssuerUri() throws -> URL {
        
        guard let url = URL(string: self.issuer) else {
            Logger.error(data: "Invalid Configuration Error, The issuer URI could not be parsed")
            throw ApplicationError(title: "Invalid Configuration Error", description: "The issuer URI could not be parsed")
        }
        
        return url
    }

    func getRedirectUri() throws -> URL {
        
        guard let url = URL(string: self.redirectUri) else {
            Logger.error(data: "Invalid Configuration Error, The redirect URI could not be parsed");
            throw ApplicationError(title: "Invalid Configuration Error", description: "The redirect URI could not be parsed")
        }
        
        return url
    }

    func getPostLogoutRedirectUri() throws -> URL {
        
        guard let url = URL(string: self.postLogoutRedirectUri) else {
            Logger.error(data: "Invalid Configuration Error, The post logout redirect URI could not be parsed")
            throw ApplicationError(title: "Invalid Configuration Error", description: "The post logout redirect URI could not be parsed")
        }
        
        return url
    }
}
