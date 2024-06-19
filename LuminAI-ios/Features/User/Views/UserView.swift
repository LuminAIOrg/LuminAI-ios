//
//  UserView.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 13.03.24.
//

import SwiftUI

struct UserView: View {
    
    var navigationColor: Color = Theme.Accents.orange;
    
    
    @State private var authorizationFlowInitiated = false;
    
    @ObservedObject
    var viewModel: UserViewModel;

    @ObservedObject
    var webViewModel: WebViewModel;
    
    @ObservedObject
    var appAuth: AppAuthHandler;
    
    @State var tokens = TokenStorage.shared.getTokens()
    
    
    private func getHostingViewController() -> UIViewController {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene!.keyWindow!.rootViewController!
    }

    
    var body: some View {
        NavigationView {
            ZStack {
                if( UIDevice.isIPhone) {
                    Symbols.wave
                        .foregroundColor(navigationColor)
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 400)
                }
                VStack {
                    if(appAuth.isAuthenticated) {
                        VStack {
                            Text("Authenticated")
         
                            Text("Username: \(viewModel.username)")
                            
                            
                            Button("Logout") {
                                authorizationFlowInitiated = false;
                                appAuth.logout()
                                
                            }
                            
                        }.onAppear {
                            viewModel.getUserName()
                        }
                        
                    } else {
                        if(authorizationFlowInitiated) {
                            ZStack {
                                // Your WebViewContainer
                                WebViewContainer(webViewModel: webViewModel)
                                    .opacity(webViewModel.isLoading ? 0 : 1)

                                // Overlay with progress view
                                if webViewModel.isLoading {
                                    Rectangle()
                                        .fill(Color.white.opacity(1)) // White overlay
                                        .edgesIgnoringSafeArea(.all)
                                    
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .scaleEffect(2) // Adjust scale as needed
                                }
                            }
                           
                            
                            
                        
                        } else {
                            Button("Authenticate") {
                                Task {
                                    webViewModel.url = try await viewModel.buildLoginUrl();
                                    authorizationFlowInitiated = true;
                                }
                            }
                        }
                    }

                }
                
            }
            .navigationTitle("Profile")
            .toolbarBackground(navigationColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

//#Preview {
//    UserView()
//}
