//
//  ThemeManager.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/06/2025.
//

import SwiftUI

final class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") var selectedTheme: ThemeMode = .automatic

    var appliedColorScheme: ColorScheme? {
        switch selectedTheme {
        case .automatic:
            return nil
        case .dark:
            return .dark
        case .light:
            return .light
        }
    }
}

enum ThemeMode: String {
    case automatic
    case dark
    case light
}
