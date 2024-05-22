//
//  AuthenticatorImpl.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 25.04.24.
//


import UIKit
import WebKit
import SwiftUI


struct Metadata: Codable {
    let authorization_endpoint: String;
    let token_endpoint: String;
    let introspection_endpoint: String;
    let userinfo_endpoint: String;
    let end_session_endpoint: String;
    let registration_endpoint: String;
    
}

class WebViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var shouldGoBack: Bool = false
    @Published var title: String = ""

    var url: String
//    var authCode: String?;
//    var sessionState: String?;
//    var iss: String?;
    
    var appAuth: AppAuthHandler;

    init(url: String, appAuth: AppAuthHandler) {
        self.url = url
        self.appAuth = appAuth;
    }
    
    func setCodeParams(authCode: String, sessionState: String, iss: String) {
//        self.sessionState = sessionState;
//        self.authCode = authCode;
//        self.iss = iss;
        
        Task {
            try await appAuth.exchangeCodeForToken(code: authCode)
        }
        
    }

}

struct WebViewContainer: UIViewRepresentable {
    @ObservedObject var webViewModel: WebViewModel


    func makeCoordinator() -> WebViewContainer.Coordinator {
        Coordinator(self, webViewModel)
    }

    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.webViewModel.url) else {
            return WKWebView()
        }

        let request = URLRequest(url: url)
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(request)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if webViewModel.shouldGoBack {
            uiView.goBack()
            webViewModel.shouldGoBack = false
        }
    }
}

extension WebViewContainer {
    class Coordinator: NSObject, WKNavigationDelegate {
        @ObservedObject private var webViewModel: WebViewModel
        private let parent: WebViewContainer;
        
        private var wasAlreadyRedirected = false;

        init(_ parent: WebViewContainer, _ webViewModel: WebViewModel) {
            self.parent = parent
            self.webViewModel = webViewModel
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            webViewModel.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webViewModel.title = webView.title ?? ""
            webViewModel.canGoBack = webView.canGoBack
            injectCustomStyle(webView)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            webViewModel.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            if let newURL = webView.url?.absoluteString {
                print("Received server redirect to: \(newURL)")
                
                if(!wasAlreadyRedirected) {
                    if let urlComponent = URLComponents(string: newURL) {
                        let queryItems = urlComponent.queryItems
                        
                        let sessionState = queryItems?.first(where: { $0.name == "session_state" })?.value
                        let iss = queryItems?.first(where: { $0.name == "iss" })?.value
                        let code = queryItems?.first(where: { $0.name == "code" })?.value
                        
                        
                        // result is optional
                        if code == nil || sessionState == nil || iss == nil {
                            print("Key code not found")
                        }
                        else {
                            webViewModel.setCodeParams(authCode: code!, sessionState: sessionState!, iss: iss!)
                            wasAlreadyRedirected = true;
                        }
                    }
                }
                
            }
        }
        
        func injectCustomStyle(_ webView: WKWebView) {
            print("injecting style")
            let customStyle = """
                #kc-content, #kc-content-wrapper, #kc-form-login, .card-pf {
                    background-color: transparent !important;
                }
                
                #kc-page-title, #kc-header-wrapper {
                    display: none !important;
                }
                
                label[for=username], label[for=password] {
                    font-size: 1rem !important;
                }

                input#kc-login {
                    background-color: #FFA564 !important;
                }
                button.pf-c-button.pf-m-control, input#username, input#password, input#kc-login, button.pf-c-button.pf-m-control::after  {
                    --pf-c-form-control--focus--BorderBottomColor: #FFA564 !important;
                    border-radius: 0.5rem !important;
                }
                input#kc-login {
                    font-size: 1rem !important;
                }
                """
            
            let style = customStyle.replacingOccurrences(of: "\n", with: "")
            let script = """
                document.head.innerHTML += '<style>\(style)</style>'
                """
            
            webView.evaluateJavaScript(script) {(result, error) in
                if let error = error {
                    print(error)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                        self.webViewModel.isLoading = false
                    }
                   
                }
            }
        }
    }
}


class AppAuthHandler: ObservableObject {
    @Published var isAuthenticated = true;
    @Published var username = "";
    
    
    private let config: ApplicationConfig
    var metadata: Metadata?;
    private let webService = WebService();
    
    init(config: ApplicationConfig) {
        self.config = config;
        
        webService.baseUrl = config.issuer;
        
        TokenStorage.shared.loadTokens();
        

        
    }
    
    /*
     * Get OpenID Connect endpoints
     */
    func fetchMetadata() async throws -> Metadata {
        
        if let metadata = self.metadata {
            return metadata;
        }
        
        guard let metadata: Metadata = try await webService.fetch(fromURL: "/.well-known/openid-configuration") else {
            throw ApplicationError(title: "Fetch Failed", description: "Metadata")
        }
        
        self.metadata = metadata;
        
        return metadata;
    }
    
    

    
    
    
    func exchangeCodeForToken(code: String) async throws {
        print("Code")
        print(code)
        
        let getTokenData = GetTokenData(grant_type: "authorization_code", code: code, redirect_uri: self.config.redirectUri, client_id: self.config.clientID, client_secret: self.config.secret)
        
        do {
            let tokenData: TokenData = try await webService.postFormEncoded(data: getTokenData, toURL: self.metadata!.token_endpoint)
            print(tokenData)
            DispatchQueue.main.async {
                TokenStorage.shared.saveTokens(newTokenData: tokenData);
                
                Task {
                    try await self.introspectToken();
                }
            }
        } catch {
            print("error: \(error)")
            throw error
        }
        
       
     
        
    }
    
    func introspectToken() async throws {
        let metadata = try await fetchMetadata();
        
        guard let url = URL(string: "\(metadata.introspection_endpoint ?? "")") else { throw NetworkError.badUrl }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let encoded = "\(config.clientID):\(config.secret)".data(using: .utf8)?.base64EncodedString()
        
        request.setValue("Basic \(encoded!)", forHTTPHeaderField: "Authorization") // Set bearer token
        

        let token = TokenStorage.shared.getTokens()?.accessToken
        

        
        if(token == nil) {
            throw NetworkError.unauthorized
        }


        let queryString = "token=\(token ?? "")"
        
        guard let encodedData = queryString.data(using: .utf8) else {
            throw NetworkError.failedToEncodeData
        }
        
        request.httpBody = encodedData
        
        do {
            let (responseData, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else { throw NetworkError.badStatus }
            
            let data = try JSONDecoder().decode(IntrospectionResponse.self, from: responseData)
            if(!data.active) {
                throw NetworkError.unauthorized
            } else {
                DispatchQueue.main.async {
                    self.isAuthenticated = true;
                }
            }
            
        } catch {
            throw NetworkError.requestFailed
        }
    }
    
    func logout() {
        
    
        
        DispatchQueue.main.async {
            self.isAuthenticated = false;
            TokenStorage.shared.removeTokens()
        }
        
    }
    
}
