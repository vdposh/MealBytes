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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDMwMTA0MTEsImV4cCI6MTc0MzA5NjgxMSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.bB9-Yhk71XiAm2ecyCCc-tFbjmLXCLdfhVv3C0qndGIOmwJADd3lo7z24BLmOXWFqEATFmMLEq6i6saZjOHryeprvPSUbrg7KxVaubi7FhgazNdK7NASOgK4C4NERCOdPOYkpDFN06LJFRuEFD4xJ7jrJFVCBE5C5uI0M-AalX93l0cF0xq2iu806Vvq9F27-_15CiGAWiJC9KxFLwztn6NcuvmWf3A0-7Axn-O7VC4WnJfQ7bLVDLiCmUrtnRKAYGUYYoFMTB3Tjx_wzHB_3xaIFQMS0nO8mmlLtwOvukSxkWQbXUc5PN7uGEN9a7uG1wjHfC_bnUl2k1HKph0CWL1qdVHxoDeflE7ihJoxGikRnIGs43HrmTiICc9VQPAYU_qHz6CkrbrLRbO4Buhzy8P0o4bNIqE4fUQidlY9bj039ISxxn2V1O-S2VCQoB84IY_sJy39GwHuRdWyx_qSzq4nbNf11dQcCHmWQWivmF2ABO0v6awSq6B1FCAC_t5O4CaeviCQm_ggeBRmNUDcHMIXJqHDPjZsOoAL6g6wW6vbnR5AOWE9Ew_r8Bj-tB-SqaOjT_VPEEsrdCeWWvmA6wZnCtV8kVa2hzPyCIN2xTcsk3fw10eh8VcOh0zOUcuMjLAZjUJyrruBFgIlE6r1xHkJzUFGGhXa8gjEVedFM-8"]
    }
    
    var format: String {
        "json"
    }
}
