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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDMxMDIwMjMsImV4cCI6MTc0MzE4ODQyMywiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.brxENWc8ffyJSJyXGiv7wU0XPc9ditITbGKe8edp0ojxlJeqMXb0JOoWswT1EWfYQ6NxkrsyNDc5t5OUB6F7bLRT6btuo9_bI4vJTPCV8zfCtA8C1xhq3zVWYZ7IZ6iIdqGNP7e7MYvnQtN62aaELLyAjShRKIftzMnScg04vASr9ZTrTbQ_iHqOvjuDyhWit9nuCMd49vHdU8kxtSxjDnV4-XC2SkmTdYBa0YUromEeJbAlE8daAK3gdpf7Kql1bL1_6mjiQqbvwR5x5TpMQhulXSOSCXEhAWdyxrjyIw5vH2YSOreyFzuCL5_gVwQwZeaYgInBVd34azF8ZeukNws0QPAWPODQYd45JdWm6aEMGTx5HND7cI5clphJI-h-dqykO0Ck04aJrDL1EEOLTClA4mZq1CSg97CXc0AiZrTyKPN6vTJtCeacGyWs3sua3HyMP50Nzp5N-57EQhnPMq6TbzE-MZZPSp2pp61g-exljHuwXMfcooaxkgsqnd-dnBm8RHoWcWop_T1nSHdTu7dlW0NQkNgaFllbYUPXCWdW7yOziSrRjTx_mtRQrqm7ILbfNSpmuOYYGVft-DtqPwtjN2fStbE7ahyOd1CFd9SI54Ibq-YXahvkcr4xNBD5DMI7n2wdWLLQPEfBuNuXoLnNevQmdWQBjtVOoqUHrjI"]
    }
    
    var format: String {
        "json"
    }
}
