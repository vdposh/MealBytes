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
        URL(string: "https://platform.fatsecret.com/rest/server.api")!
    }
    
    var path: String {
        ""
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        switch self {
        case .searchFoods(let query):
            return .requestParameters(parameters: [
                "method": "foods.search",
                "format": "json",
                "search_expression": query
            ], encoding: URLEncoding.queryString)
        case .getFoodDetails(let foodID):
            return .requestParameters(parameters: [
                "method": "food.get.v2",
                "format": "json",
                "food_id": foodID
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDEyNTY5NTMsImV4cCI6MTc0MTM0MzM1MywiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.pFa2AAcII52DR4a5fpBzhDnaKu0mSXpV45GJbqPMuGsAWJkOMGnDt5oyhe2vACBgqhT5JtSuZIzgQudD-p5EDwxJDzEI-s9wEOfZhqErM3kMUbj5daxdlvpO6hnTW4owJVMSw7C5KcWMdIT5b-jJeE_Rb4tisj8xRI5ebrj-RZc8GpFaRnpAiUIqrxPsSq25hjR5Rf2TBtcSdUA9DC-HfwDpPmoVinQluD-2GJrGwEPwKlKPTOpovDKIBNxc50bbJZvjTEbn-IpWtGZULH0eHMHO_kzTD1Ba3jNAmdUhF0AU-CQkGs5qmYiDBfyAj-HtLSrToDJcysVcmuBhnLDxIk3pxBzZ6KzK23lke9naeDnVQMQ9OD1aAS2nzfbGLHXKbamRiK07raDw3T6SArgHmp5MWLq-PFbXsFobqwglfGIN6GUOiyLoRVL8qv5ulJ0fcG_1WvDGlxiFx4iFEBwv3KRFFpznfoD50ZYns6KKA6QRgH5gSEG3R-8OTcYRx9hq9bKjjP_wmooUzNndCAY-czNq3Bwwv2aUE4qseIXrwS9SlKRA11kZMf72CR_sAEUCJ1t0lMarZ5Y61nBr6nNGfC_s2E4pDVjnIldCWdBFt1WwZsknyWaLsF2vN1pi8wWzIztw4JmXG4xbHPqIb2BYF4xZvLTayFYDb4s6gXNSROc"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
