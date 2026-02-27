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
        case .light: return .light
        case .dark: return .dark
        case .automatic: return nil
        }
    }
}

enum ThemeMode: String, CaseIterable {
    case light
    case dark
    case automatic
    
    var themeName: String {
        switch self {
        case .light: "Light"
        case .dark: "Dark"
        case .automatic: "Automatic"
        }
    }
    
    var iconName: String {
        switch self {
        case .light: "sun.max.fill"
        case .dark: "moon.fill"
        case .automatic: "circle.lefthalf.filled"
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewProfileView.profileView
}

#Preview {
    PreviewLoginView.loginView
}
