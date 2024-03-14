//
//  LuminAI_iosApp.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 08.02.24.
//

import SwiftUI



@main
struct LuminAI_iosApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Symbols.homePageIcon
                        Text("Home")
                    }
                DevicesView()
                    .tabItem {
                        Symbols.devicesPageIconActive
                        Text("Devices")
                    }
                UserView()
                    .tabItem {
                        Symbols.profilePageIcon
                        Text("Profile")
                    }
            }
        }
    }
}
