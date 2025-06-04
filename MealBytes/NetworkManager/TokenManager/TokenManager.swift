//
//  TokenManager.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/04/2025.
//

import SwiftUI

final class TokenManager {
    
    @Published var accessToken: String?
    
    private let tokenURL = URL(string: "https://oauth.fatsecret.com/connect/token")!
    private let clientID = "b9f183e691a64e54b1181a8cdae19a4f"
    private let clientSecret = "bf1b1b039b8f435bbd5a724220d5e333"
    
    static let shared = TokenManager()
    
    func fetchToken() async throws {
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        
        let body = "grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSecret)"
        request.httpBody = body.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(
            for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(
            TokenResponse.self,
            from: data
        )
        self.accessToken = decodedResponse.accessToken
        print("New token: \(decodedResponse.accessToken)")
    }
}
