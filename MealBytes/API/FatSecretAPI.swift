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
    case getFoodDetails(foodID: Int)
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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDI3MTE3MTIsImV4cCI6MTc0Mjc5ODExMiwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.NX-xdziiSN5EoVHC4SbVBifz8rp_pZo5yQ3zncf1V1-I2h487GgVZ1eLAxiDN-hhk014jVNkJkqnJKl8MGFfHGdPl6vBw8dBEBl0mWehhyFvak5flFIlMOgXnA128GzyeJshuS-sdnyhzrMZKLXXUJw5xWsMwSNsGH85L15Ha15TEKoKQln-QyTTSlzyDb4AjStOsaNxbc6ORFLqCJMPEe3ocYWQMT8aaNiweA9BQe1DBdS4Dsgw_1cnbW8aQvsjxAPLP75jrD9uSpm-eCxTlFPbylT6IzAwn3IHgvUuyx8dW7NcEdbQUBRxTWkqqO8Ea490EqpVXbQL-yJi1y1aWTlp4iy4gTjCTsaACva42RXk6B5vKingbNwOAKf8YFaFDUQTsCNfs7o6Mqzz7-NbnZpV4mi1JJhhwebbYrVCSt_EYx86VWSterRxS6SCVbW-dgNvLBw2KzdvHEJwXAUpB0eX1CB_NOrMDkxfUxg8UfTvRf8m6V3ptrrk7uPGXBHBU22SY7CpXLe_SsZKcs-P7rZJmZRr555Xw0iwMiAtJr2Lwasjg5SwZTP89RKaNGMXfi0Ae3kFS4KMlH_mqivl0D1j0s5rN5fkNapsKvlzKJjBfdNSdNtSHQEJucuZ9agCYNoKdZemNEs1MTlAJRNdBp_13yIQBzjUlhCn0IKq2yA"]
    }
    
    var format: String {
        "json"
    }
}
