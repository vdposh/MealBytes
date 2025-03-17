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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDIyMDY4NjEsImV4cCI6MTc0MjI5MzI2MSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.Vz0UH_-PLsRkbsHX89FDKbch4GqpkSV-Hynu55xQ9V7ZB4AUxxNYfqDfyWOHccSutpglZ5jamwppxeM4qUtuyNveSmZRY8G8niA2fw5A0CjKdbpbj53KDYnUFJ3MtKcz5cgXPIh8Eh1uNUfBSp-1VYCydlwTLkRxUAunea5oWTVxgJZeLrL07sRpL4yML-IITSt_GmCrvWXJPqk3Jesb5iqOpDpGCvouqvqQLyPJ3h5h-9xzk1LNyUT83MgIOpJlK_ImXZZt9Bf_PnYNOZLWi7DhMZirLTTqj8TaiOIg_-ClwZRHixoP39Ezo-Nb_J2lzzQNdCuI_hZ3mFQ32udzWwdaJVGecZAD4CZALeM1pFWzgqLRz0Dr_jCkETsNpi2qZ9c1LbQ4y0NuTUI-4u3DPuJUG7vW-aP0IUavmgUxIdoep-s6BFb5iqzMqs3fQHCXlak_ijUd-XPaIkDDyA3n6uPOZiKqwzo5mjqFkmon5Mpw27bNGhxRU0fhAdKWTGUtU5NLJx4H_XPYw5x06cFxIDVN7n92lLqKPqoffiXr_GMFafDPaQ_bWe4frdJ_AV9w678J43dTe55EUotUmskS3U0jwZ2vWC6CeUTbpbFp5S_Z_D9i9l0YmUtU0FJghwDCtEBeaS_C9xJmgQOOH3MIAL6fBsvsFjrVwTu629RZ_O0"]
    }
    
    var format: String {
        "json"
    }
}
