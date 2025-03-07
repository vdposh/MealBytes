//
//  FatSecretAPI.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Moya

enum FatSecretAPI {
    case searchFoods(query: String)
    case getFoodDetails(foodID: String)
}

extension FatSecretAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://platform.fatsecret.com/rest")!
    }
    
    var path: String {
        switch self {
        case .searchFoods:
            "/foods/search/v1"
        case .getFoodDetails:
            "/food/v4"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        let parameters: [String: Any]
        
        switch self {
        case .searchFoods(let query):
            parameters = [
                "format": format,
                "search_expression": query
            ]
            
        case .getFoodDetails(let foodID):
            parameters = [
                "format": format,
                "food_id": foodID
            ]
        }
        
        return .requestParameters(parameters: parameters,
                                  encoding: URLEncoding.queryString)
    }
    
    var headers: [String: String]? {
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDEzNTYxMjgsImV4cCI6MTc0MTQ0MjUyOCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.PaiNETHsOOxPaUCKxN0OQtLredef9r3j_KwWuAyyFfbGhb8zHpAkhWIOVN_T6QibX4k7y2asV4GISyUiV04PWFWBIe5WEqwOeAVNc7-h_7MrTmZsqPikFBiEfjFKnlFi8Vdg1NXf4beO2GurDP3U9FMXJVpSlocR-jzla5H1u4krReH82q6GTaD_SQzLdFpapOoiJufSaXDyzG4d44Q88iuPDd_fJ2AwXJb6LMh7dGOkT0g8YKBPOYRijt80a2bvzuS6TLY0Qp1JAdrMXsg7VYs6QgecRQoAtUleJ_zhaXgkUaOVX1hnQB5a5Y3V93nhkcVvrKtcp2sUgTgmEQlCswsjeOwN7gp8hLTLLj1Fnhar9YqO-EXOyGV_bg7vXE-XR5azNW3GASyPK5eZeikDy8WWAiiZ7GLXlFcAE9raZ4VDoF7fygOQjpisKxsXg49r2nESzpoyYUuMG0bbRimcEMKfoACPHStbSDD3mPiu6t4wnS9ytoWSSMRPJg0ch3Yp-3eabx2621OUbut8bh451QXVLCxO4lZOK0zwW56YByzPxqpF9Z9nPx-5rUxLnNRRXIUiIlTgLSJHnEoTKqGw0CBOEkrUWG-6soS5Esz19eyRmTiB7brevzoRJ73cwQ7Cb4GRzrkWn-GWd1ZnxCOcXsz7wRGev0OJJ3I8kMGLFuQ"]
    }
    
    var format: String {
        "json"
    }
}
