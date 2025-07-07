//
//  Servings.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07/03/2025.
//

import SwiftUI

struct Servings: Decodable {
    var serving: [Serving]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            serving = try container.decode([Serving].self,
                                           forKey: .serving)
        } catch DecodingError.typeMismatch {
            serving = [try container.decode(Serving.self,
                                            forKey: .serving)]
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case serving
    }
}
