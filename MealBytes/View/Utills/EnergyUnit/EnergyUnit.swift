//
//  EnergyUnit.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06.10.2026.
//

import SwiftUI

enum EnergyUnit: String, CaseIterable {
    case kcal = "kcal"
    case kj = "kJ"
    
    var title: String {
        switch self {
        case .kcal: return "Kilocalories (kcal)"
        case .kj: return "Kilojoules (kJ)"
        }
    }
    
    func convert(fromKcal kcal: Double) -> Double {
        switch self {
        case .kcal: return kcal
        case .kj: return kcal * 4.184
        }
    }
}
