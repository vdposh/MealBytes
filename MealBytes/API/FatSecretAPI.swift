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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDQxMzA4MTMsImV4cCI6MTc0NDIxNzIxMywiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.Va2kHgU52BqL_Ndf9AUWj4kzuF3pSLi_XVyEMe2TAjLrp4DRivLKy3Sd2UiuYn5g1Mj8foj9iRHnYKtF204g84Z59OHF8jtCMQyY2GTT5NIyTLpHhTyq4BhIb7CT4P0oYK6vW1m2-M8M9GEsRg70ig9F0zi1mCvUTLfPDfR__yg1ZWeDNpeLq7J4sHzDu5JAsdpl__uo8wRBG5HWWyROJfKZpM1KWHbT7mdB_8M41VHHxgPGUMQrOPYsruRiKxLb0aqHEUIXMvwYpl6qnbrrrxph3kSjAkLYR_4jgk6ZsbW28HTaz0c5jP2WVoRHYGR7FuxxBe4dwHqwv-uZ8MbKAzmoScpXHeoRAVJ2Qt-UbiqQqo3kxnmLVTR-YQr3wAIqj0tbUD3UuX1DjLdtzY1WMm40FyZZ4nQBBoxvmZuh0njA4qc4jLNUDeFLnSSHK_WWm3-6HXS9SpLg_O3AyMO8_U0Eu873vZ8_ehxRqitUZ2kuaJxpSzIYRVQQgIiwgZblHhfKlt9Xa7qJNT6BEkLJssQv-3_DsQ0LltYQTDxPCotbKlO5ynR89C5iC7geYnIUrfLuMMQ1ST1agv6YDQO5aeSSgdktOW6DtGSpPvwwfgW0BuA7JVGa7teh2UtH8BQBSUrsFr8TIbBH9fHgaMh7hhVmDMTlncSI3qqGYs6tbTk"]
    }
    
    var format: String {
        "json"
    }
}
