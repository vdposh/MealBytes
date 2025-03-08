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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDE0NDU0MzcsImV4cCI6MTc0MTUzMTgzNywiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.L7YskSEW0MOUfV-65dwftMHOyErTXBU-XemWfs2F-pbY1VMqw07Tulvk470iXb478VbpAYZmyMHfuXU2GdQBGk63Auyugef8p7OJN8u-LBptxzmnBNDhxzGGnIAS3twjjGc1yQeLGGgEcrVF_GHGpN_YrxJDCbDGIfvH-w47UjEJND2PrmRc20ADwWCKCNGi9GYPOsmRNYPHhGLkyEK5yKxRjxRJ4SGLycohaoxiM19tXaZp5re9kkjMIcfR7GLiiHiTclr27qdxrpK9pjRvr-PDJ5mZYpEhgXKfp3fzrWSBL0o9MvHgY5quCjVgWEOzLNQc_-W_xbL5qtwouFht0bnhlXagUJjtCFh5qulsSSwHcXjOoGAvaVy8fneNhr0ZkRXAb-gMdV30QObQvHdcUdX9boWQJt9nPDhAI5cIxZnxO2hOOlcGncrb6UbtpgX0jPOwAvsay7t2RaTAUZ9wIueXeXFqjyow7Jn4jh0P_KUS7BFlrGyVppb9qlHSJQwDv_URtDzFDZCKv476BO6b6Q_TmGRbrt6f3GuK8EnhocoIJrdml2vkrR2PnfhYGi2O_Hu_H5JXn9J7ZFVn0ND9_c28dSg6R7vDOhlEdsDooIYfniVhyKSyyNYQYh3wYDAkwGrHgMDZBExmL36pIqg_bxOBJt1WUjV6zaxLLLGVWyI"]
    }
    
    var format: String {
        "json"
    }
}
