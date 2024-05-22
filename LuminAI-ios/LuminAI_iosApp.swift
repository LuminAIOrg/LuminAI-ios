//
//  LuminAI_iosApp.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 08.02.24.
//

import SwiftUI

import SwiftUI
import UIKit


@main
struct LuminAI_iosApp: App {
    private let config: ApplicationConfig
    private let state: ApplicationStateManager
    private let appauth: AppAuthHandler
    private let userViewModel: UserViewModel
    
    
    func onLoggedIn() {
        appauth.isAuthenticated = true
    }

    func onLoggedOut() {
        appauth.isAuthenticated = false
    }

    init() {
        self.config = try! ApplicationConfigLoader.load()
        self.state = ApplicationStateManager()
        self.appauth = AppAuthHandler(config: self.config)
        self.userViewModel = UserViewModel(appAuth: self.appauth, config: self.config)
        
        WebService.setAppAuth(appauth: appauth);
        
        self.checkLoggedIn()
    }
    
    private func checkLoggedIn() {
        Task {
            do {
                print(TokenStorage.shared.getTokens()?.accessToken)
                try await appauth.introspectToken()
            } catch {
                print(error)
                DispatchQueue.main.async {
                    appauth.isAuthenticated = false;
                    TokenStorage.shared.removeTokens()
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                TabView {
                    if(self.appauth.isAuthenticated) {
                        HomeView(appAuth: appauth)
                            .tabItem {
                                Symbols.homePageIcon
                                Text("Home")
                            }.tag("Home")
                        DevicesView(appAuth: appauth)
                            .tabItem {
                                Symbols.devicesPageIconActive
                                Text("Devices")
                            }.tag("Devices")
                    }
                    
                    
                    
                    UserView(viewModel: userViewModel, webViewModel: WebViewModel(url: "http://localhost:8080", appAuth: self.appauth), appAuth: appauth)
                        .onAppear {
                            print("hello")
                        }
                        .tabItem {
                            Symbols.profilePageIcon
                            Text("Profile")
                        }.tag("Profile")
                }
            }
        }
    }
}
