//
//  UserViewModel.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 25.04.24.
//

import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    
    var appauth: AppAuthHandler;
    var config: ApplicationConfig;
    
    @Published var username = "";
    
    init(appAuth: AppAuthHandler, config: ApplicationConfig) {
        self.appauth = appAuth;
        self.config = config;
    }
    
    func buildLoginUrl() async throws -> String {
        let urlAsString = "\(appauth.metadata?.authorization_endpoint ?? "")?response_type=code&client_id=\(config.clientID)&scope=\(config.scope)&redirect_uri=\(config.redirectUri)&client_secret=\(config.secret)"
        return urlAsString;
    }
    
    func getUserName() {
        Task {
            let username: String = try await WebService.shared.fetchWithToken(fromURL: "/api/user/username");
            
            DispatchQueue.main.async {
                self.username = username;
            }
        }
        
    }
    
    
    
    
    private func getViewController() -> UIViewController {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene!.keyWindow!.rootViewController!
    }
}
