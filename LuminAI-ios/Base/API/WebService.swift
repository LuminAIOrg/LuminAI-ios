//
//  WebService.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 14.03.24.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
    case failedToEncodeData
    case requestFailed
    case unauthorized
}

class WebService {
    
    var baseUrl: String = "http://localhost:8080"
    
    var appAuth: AppAuthHandler?;
    
    static let shared: WebService = WebService();
    
    static func setAppAuth(appauth: AppAuthHandler) {
        shared.appAuth = appauth;
    }
    
    func fetch<T: Codable>(fromURL url: String) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(url)") else { throw NetworkError.badUrl }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else { throw NetworkError.badStatus }
            
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.failedToDecodeResponse
        }
    }
    
    func fetchWithToken<T: Codable>(fromURL url: String) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(url)") else { throw NetworkError.badUrl }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let bearerToken = TokenStorage.shared.getTokens()?.accessToken;
        if(bearerToken == nil) {
            //self.appAuth?.logout();
            Logger.error(data: "Logging out because token is not valid anymore")
            throw NetworkError.unauthorized;
        }
        
        let tokenString = "Bearer \(bearerToken!)"
        request.setValue(tokenString, forHTTPHeaderField: "Authorization") // Set bearer token
            
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.badResponse }
                    
            switch httpResponse.statusCode {
            case 200..<300:
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    return decodedResponse
                } catch {
                    if(T.self == String.self) {
                        return String(decoding: data, as: UTF8.self) as! T
                    }
                    throw error;
                }
            case 401: // Unauthorized
                //self.appAuth?.logout();
                Logger.error(data: "Logging out because token is not valid anymore")
                throw NetworkError.unauthorized
            default:
                throw NetworkError.badStatus
            }
        } catch {
            throw NetworkError.failedToDecodeResponse
        }
    }
    
    func post<T: Codable, R: Codable>(data: T, toURL url: String) async throws -> R {
        guard let url = URL(string: "\(baseUrl)\(url)") else { throw NetworkError.badUrl }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(data)
            request.httpBody = jsonData
            
            let (responseData, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else { throw NetworkError.badStatus }
            
            let decodedResponse = try JSONDecoder().decode(R.self, from: responseData)
            return decodedResponse
        } catch {
            throw NetworkError.requestFailed
        }
    }
    


    func postFormEncoded<T: Encodable, R: Decodable>(data: T, toURL url: String) async throws -> R {
        guard let url = URL(string: "\(url)") else { throw NetworkError.badUrl }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Encode the data into a URL-encoded string
        let queryItems = try dataToQueryItems(data)
        let queryString = queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        guard let encodedData = queryString.data(using: .utf8) else {
            throw NetworkError.failedToEncodeData
        }
        
        request.httpBody = encodedData
        
        do {
            let (responseData, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else { throw NetworkError.badStatus }
            
            let decodedResponse = try JSONDecoder().decode(R.self, from: responseData)
            return decodedResponse
        } catch {
            print(error)
            throw NetworkError.requestFailed
        }
    }

    private func dataToQueryItems<T: Encodable>(_ data: T) throws -> [URLQueryItem] {
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(data)
        guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            throw NetworkError.failedToEncodeData
        }
        return jsonObject.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
    }


}
