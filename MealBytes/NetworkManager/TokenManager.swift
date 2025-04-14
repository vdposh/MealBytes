//
//  TokenManager.swift
//  MealBytes
//
//  Created by Porshe on 14/04/2025.
//

import SwiftUI

protocol TokenManagerProtocol {
    func fetchToken() async throws -> String
}

final class TokenManager: TokenManagerProtocol {
    
    static let shared = TokenManager()
    
    private let tokenURL = URL(string: "https://oauth.fatsecret.com/connect/token")!
    private let clientID = "b9f183e691a64e54b1181a8cdae19a4f"
    private let clientSecret = "bf1b1b039b8f435bbd5a724220d5e333"
    @Published var accessToken: String?
    
    func fetchToken() async throws -> String {
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        
        let body = "grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSecret)"
        request.httpBody = body.data(using: .utf8)
        
        do {
            let (data, response) = try await URLSession.shared.data(
                for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decodedResponse = try JSONDecoder().decode(TokenResponse.self,
                                                           from: data)
            
            self.accessToken = decodedResponse.accessToken
            
            return decodedResponse.accessToken
        } catch {
            throw AppError.network
        }
    }
}

struct TokenResponse: Decodable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case scope
    }
}
