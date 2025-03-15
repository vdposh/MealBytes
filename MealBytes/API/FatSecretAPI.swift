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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDIwMzMzMDUsImV4cCI6MTc0MjExOTcwNSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.AoGpXScuec8RW9yu-zkwvgMi_27VA1YatQwxL0gg3mtWZtOibgnZBKCDc_OJt4yqgnA6AK4jED9mNUQ34YxlhlrLKqpkL78gODOTAplHO4SaYr0Cxg3HHDyeHGBTlIhRDB_sdppbnqhi-Bf8JfW208BTR4Em3Ji9nAqd65-FAnAks0E2hEWpf6QgRqvuxJetW3mZeKC-EzpO9563HSGi0zy5NuGyqmHmz7nge4SN5cYPU8VMbGgrDL-ao_hqo3jeDpHk1zLb0YBGu6om8VdvX20434iAtl5nxGQGTi3ZuGrM2d1XlKX4iEI8ufXfgQ2QzUvj1c7MlnSCZXEeg72JeJUhpZi6rfyhLi-uIDOKPceRZoAgO2Le5Pj5sXC4cihbVYT_ag14gd4qcdYCx72WGbCSl-9NgZeuKokbduD_XLZq6ZxR4BoPGEuDRcH1EmIBrIlQKakNfDsD0LHYqaPPDaiMNStTlMoUH7i8Ujf3YmOJpkovndyVrVZoXqBicCUEy9-2e6F8j7k1Nkj4IZL57ya2f7i6JD3NBX8RXVz2LT8ZJBRPAOtI00lsOsOVCtnwdvv56qS_flirRllbXKFE82gh1du2F0hPjXctN5RYxAVMlNOe-mO_f_Ct5H-qL0JyzpvPkd_dV7yiX_Jb6l1xL6ydLYkzSmNhN_gP7xpx6LA"]
    }
    
    var format: String {
        "json"
    }
}
