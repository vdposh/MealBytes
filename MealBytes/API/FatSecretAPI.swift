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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDE4NDgzNTgsImV4cCI6MTc0MTkzNDc1OCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.DXxXOPQCj-SHG8J_oGe216DlzZpQxU1YPXX5tn7q2mWdaIk5zS4hGCw1fQBXOVGqGo1gEbkkvlQqrRvjDL-jn-DaTbkeOmJSIrjMM5QCtgY5R0n_qEjPQEWmig9evJ3yWwwVkczHOhBioiND9RvapgZXOFJsjKigfD3aRFW-MpCWcGtgdiI-D2JFBSwp7-tJUWdSRs2Njd8D-mDcnEUhm-2XbRjg3qFF1yQLPSvw9M0qxH38raJsEfG9Vjri6Ig28W_tH14XlpqA7rQ2DjZha9uvsLaari20gBZuHLF6fFfVoGbgCoCBgifgiwzRnwDIXNg0MmXRJ5BZ3sZ-VtHEpe8s-t36vmwFneQ3ccz0ju6_8Z3Qv0vgmqOuHJNUMHH3LOgn8xHCh8YBkl51OYn-6NbbhCeV52B8KUpm4ELE9CzwuhDIg8EcDSLhmXe2bmnz8VTELy5tCaLkwSWRvI0j2AEH4h8jMtWogmDCjS57S2udRAYjwE4SnRwrfFWSnOd1D6syRdaTr9vvjipITwfST4N2bCnYjZEc5mq0EzklENn14x_IlbP8NlrqSUfa39WqtkhYqc66sDh6jYnrEw5KguhfFq4YOCNZk7rDsw3E_OfibQrJlUs1EYJX4eoD_z_-NwYyy_xEvltfVPCX8iuJNfeZ4hq37pk3kAF8WJReZGY"]
    }
    
    var format: String {
        "json"
    }
}
