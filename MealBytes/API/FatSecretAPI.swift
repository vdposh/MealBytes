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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDIxMjAxMzksImV4cCI6MTc0MjIwNjUzOSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.mfEvjQa0hrR76kpo34Q5VjEF4IEzsRs2is1ln-8Z3e_05ykiVTs-Oy2YsKoJ4nysd7yI68WnN12FDx7zf6xOvLfps7zS--dqDoiT2cb2_W3216wNT5z_Xuj0MaYNvae0Sl2nZLN9XB2aeLb7S90yLUYRq_GnootU6kHvDAcnKBeMETaQXM-QJi0C-FitFvqpGudOPQ2fPukeg6Iut4WgJuE4CixEkdVNcJhV5xNTt72roi74lhezo2lG9gh8YLfXaUPsbfNBIQFHi1FKvnFJTo-ti1_CR98BBb3vJeGcfNAycRBICJXT7jvHfkPOe0NrFZtGQz1hzkDn9YUja88b1IhLp3Zbl9md3PHC1mUgNiPV4nlXhEXond4OfPjy2dmGk_haea7Poob1RQymNwGI7n5jzuY8GqtjKBdbGGQ4UYbVVOsxDakuaz5OFlvIY14PquZeuxMGG_beZe6xg3pPbcZW2VRPoeLkH9FD_stC-Zh4lPqSoNu0wNAcDspa-t1Yip9Bc6zn6NHWWU-um2JXnqskR4ncz_wK4hQEfBrkNEKjmDDKRAOQoMnyI-jQUqihb6MaYh1wpUexSFL6se6_AX0sm0k01NWmBgM6u8WRVzdSI_s7ZOeHr_UVGLP044q7l6bhFTnS0gpruB58AR4p65QeDuHnxuTF-fQ8FAy17dk"]
    }
    
    var format: String {
        "json"
    }
}
