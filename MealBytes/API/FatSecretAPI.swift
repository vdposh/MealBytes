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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDE1MTY1OTcsImV4cCI6MTc0MTYwMjk5NywiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.lEzGL5_fsuv4evwGAwOT0ljeUwByAr2ZrL87npSy-u6c2zunYEOOyCxQIdqp4M-_xYMT-noF7rZXxienvt9chbpeC6G_lfPNtI8HmMlM8kIoOKLV-vD4wbVY0V7FUswQliZpO7AqZCzOWR-7VIeLYwXND72REg6W3MfSg808asjNGW1Gdum9YjyO8o7wnl-1ueS5Kbncob2bAezAkSOefc9E81Cdw7YJTsJTbvyekzWxttWKxlNd8NvpbO7zuHNxjPaS1zi_n_jViQNfAgC3beJ7ENJyzb8blNZAT60jvcrzm5H7OoWORrbIshkMagaLgmXy5vIcOdWi8tPVa5B5JZ_94ubJR-xE9ma6Jtu9S6dJkJ-TZWfhJyTzi3iU__Vhqq9Ox6jmb-f49S5wbx3eZ9Y5doN-7svaYrm7XbJxUoGRuh49ODqfLIlw0G2mTaLgWpnsVSvgU74BETo6brRa4zunZgZbAFj0TeU_QgmP591NcvNJRSmQ7hRqehXswIALZ-FKSlYcfAe2MCvTmOeM6DLw4ol1quWQXpHuAUrq8O00xlm1gxmWxfhMZ4Sw5xjisfaF2pBURp31sQOAvZRes1xPXsWqiK13vDJO0TWkkKrevdTHKx58w5zV0VqQn3QBLUoixuhdzpmXl70LM-zZJxCFphRbHit4JFrn54_J6Ac"]
    }
    
    var format: String {
        "json"
    }
}
