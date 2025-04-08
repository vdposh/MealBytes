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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDQwOTc0MjEsImV4cCI6MTc0NDE4MzgyMSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.nSiGgItxanlO9bArWDqaOtC84QUF1DVHxOQg66ROKqDaQZ8b-rlQJawVStJRxNnDbE_o0cWuxLae6tOlH9Wh7ZdgUsGxeRgXrarJr2BPF-2FQc_vHZVbGv6wBa8R9hRPg6rEEQ7sShkGLwWfD9Kj-r5uUe6qvKZwtgTcmsxorzvzgRUihDng-ORBo6tGgnnAmN2Srv3yVoX_Ua-FRAM7IQUWWEwDq22maZnmCrYpcQmGnmfud1aqeNI6cMPlBhoJ8yGdKtm1b-57kzJP_ETQ7FkFHXLD770tgCEdYu1HnfEe3IWDSY2r7HTlHwBg8jph3FevCk6Qm3mNT8rhU-AHJ7_oFJ7PioOCFKpdAhmkCzavG3ui0TI4u3UNRaOISp5F9TjO2gV_lH2Hc_cGzccprhdR0ao84wSIMSC67txnRDXrXecMs__b0ya_S3GbmWodJKt6QqJ4pEMWUDxktwu84ZMrc_4rbmJ1AkOS8R9ZgNvU79w810578ViEMxXzuSAdrPRe-BBBbbSEouA9kJ3cjxse8wtrPIVIcD7fHoZdd9YdkTSUsebvZvdR8arnHQuviIcfLlDj4WiBAvTglzTH7YDc5-LZDoGsWEEnXmBgikU3LX_bE3DKW62EOGB6-he-MCPMckC2eQygaUNWFQdJhP13oi-N82XCxHOa3oON9MY"]
    }
    
    var format: String {
        "json"
    }
}
