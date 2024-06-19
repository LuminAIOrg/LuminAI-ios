//
//  LuminAI_iosApp.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 08.02.24.
//

import SwiftUI

import SwiftUI
import UIKit


class RotationManager: ObservableObject {
    @Published var allowsRotation: Bool = false
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var rotationManager = RotationManager()

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return rotationManager.allowsRotation ? .all : .portrait
    }
}

@main
struct LuminAI_iosApp: App {
    private let config: ApplicationConfig
    private let state: ApplicationStateManager
    private let appauth: AppAuthHandler
    private let userViewModel: UserViewModel
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var selectedIndex = 0
    
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
            NavigationStack {
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
            }.environmentObject(appDelegate.rotationManager)
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
