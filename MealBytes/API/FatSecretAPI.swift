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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDI0NjgwNjgsImV4cCI6MTc0MjU1NDQ2OCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.V9BMYizd2DyH44mIryy-V_s5N-W5kRGdFbCoYMPmVfSSsg-bKpelgmqIjJRUi0CUTdse6c_FVDt9GfaPL_jV4CwsE3fcgUmCZvAyk3DSl-AAmkTGd0UcSkecfMjNx1oMHf0Vvj4GuTvfCkO8eLNT4rbND5-u_H8JUb29T-86A2gWdZRyKVDi0ci4gGjtopJgQUN23LPd8c3IK-JtgWi5KsxYehP0-u8oP3HebTNQLDO6s5h_s7fxUsp9EZkiTEpsj01_Cv6ulLJ6gOduViDO4tQvCgJPEjzZ39h7qrTUlywIRagzUrVDiPPnpCiSxql--cwsRr7_JrVhDotKmnf5p7A20tOgZMDibv7p01zoCdRmaV1mVaDNWQCBt__-ES_OZSr6Jhc1TRVogZvA5ErZT4re9N9f1JO0XZIk12gpRz4OTy2dKlaq82FDpJeB5r9th7JHeG_HEH-kt4CuIVlvONdkyomp0xAPfXnfWQCGrHjb0w2MD_JZknakNiS7-tLSR3yFPIVhVD4Vbi0UbG-8XkxyIYL29V8jna2NwVvds84RAnjRwJFRZVo_KTR0FyOtASqVSXh9HIOJf-JTuPjJKxRoMjoUL7Sdz8ASy9oJcEaeTME8SnROuwUWEyK64Pgp37LTHZ6R7_OWFSh6S_CSi0Hnn6mpIf6l9zXXeEVp3Ow"]
    }
    
    var format: String {
        "json"
    }
}
