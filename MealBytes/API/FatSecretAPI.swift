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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDI4ODU3ODMsImV4cCI6MTc0Mjk3MjE4MywiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.ftf_xkLXJksI8TpWG7fnPhzMjUJqRKorqN61_TZ7mkE36XahZuDgJE4VIWDopz9zaI0XlciWj8OHssX7ckxeCn-2x9NJ7NQUSPGz1vYnB1ormwJyD90kUoze6z0p37ZkT517x5_I1HeR4uQ3vcK439ctMjUYecDBxN9onJwwmd4BtHOrREZXkhlW9K1afyQbZ_SQOXcj6eSaxw_Gzd_R4DzRYwFXfOZIKGFOE-7CiDYvfhKTr5B0yRDdWte5E50AJeOwGhOGp85nRuHpDQ8ili20oKpq9cktInvVRaxzmwu0VrtSWbNnShpV3HhJrkzqv1_uesGpKbyEAnuk--dZSbsjqGU_4-RwJe2sGZXoFgYyFFVrswLxmuWxZF2UGZf-DBRE7Bh4qhnetGzKT7a0-ISrybJJ_4PuL-8K5YnPXcauN60fMrJA39-GEOoC3xafc0Zy2Fqf7E55OTfSdos8vljdWq6YOi_OjpmRrEUyaT6eGb2IPNr4QbIjLaXMoZJojAfa5134zoiULpsUOKfTzBqL5oCGJz3lILv3oR1WbxW4lmuArF0pWPxoVDlk1zDgKBJheREgf-WyQWI1a-ItlztV_lZvC3xBzNntQ9AkimrKIXYA8tOwB-E8JtfGhOfmfaCfl6SWXgbdljCxl_Njvw8sd_4IUeU_zSHgaZnd1L4"]
    }
    
    var format: String {
        "json"
    }
}
