//
//  TokenResponse.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/04/2025.
//

import SwiftUI

struct TokenResponse: Decodable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    let scope: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case scope
    }
}
