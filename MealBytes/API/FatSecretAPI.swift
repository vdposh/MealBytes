//
//  FatSecretAPI.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Moya

enum FatSecretAPI {
    case searchFoods(query: String, page: Int)
    case getFoodDetails(foodID: String)
}

extension FatSecretAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://platform.fatsecret.com/rest")!
    }
    
    var path: String {
        switch self {
        case .searchFoods: "/foods/search/v1"
        case .getFoodDetails: "/food/v4"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        let parameters: [String: Any]
        
        switch self {
        case .searchFoods(let query, let page):
            parameters = [
                "format": format,
                "search_expression": query,
                "page_number": page
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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDE3ODEyMjMsImV4cCI6MTc0MTg2NzYyMywiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.QD_fG5FyXn7JkbbiGi6nAWtA_cVSesTW9rbM6WV7XozqdSsZY1r3sfn79t01eRtwTo44K0YLbeMI48Q_G4s_m_UWphES764D2NqEEoe4ip0U4R2pIUZk7S4ZK5BsSAWUC0uDs4RamCRNQtWcTR5IJ7Sz0WVLwV7yORl-SaBr7It0xC5yZVwKMMJ2t9ZVklfmMjMFIGQTT1u8J63U5JQrGI6SlVnSIqb0Xw9v3CFkqMUKxZtiXImJ_dUbwI1zQh7UI2B3YZQ_vWoZaCcekhs0O4owWPMkk-zrXj6ZZWmBwZN-u0aPJTV8RCsJTNyz4JZCNSIHB6Zmp9gYJP831oy40T9XXdbnv7kTzjn1jYPaNuLXamZWpPkH3lhM9sF2yFEmf_bvzcV3a0kZMJ6lKAu069nr4V_wgS5WGQm0uuuPhdqsfMdVb18NgHc6ESYN2XF53R62gtRYjKaNC3v5PYJXfy-ksF6h4eZXXVKf9ak8MiqILBzoNEvgKRpl7XYkknm8iCyFYNffk0gHvNeyAbkJTDM_fNAoOYqgL4szkvUFNZ-EKrhWdMm_b-2kv2-3bnlDP8gnv63GDvTDOQgkjRYI6ZloEzF5Cjp5Sxoqfip68ml7ZyS_O60YNPr1nRhzpuJPs59ellLowTAW88CyWHz9WvzEzsJXX7BLUjezCwLxMyk"]
    }
    
    var format: String {
        "json"
    }
}
