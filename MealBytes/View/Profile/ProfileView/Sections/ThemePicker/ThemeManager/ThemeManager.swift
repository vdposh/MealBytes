//
//  ThemeManager.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/06/2025.
//

import SwiftUI

final class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") var selectedTheme: ThemeMode = .system
    
    var appliedColorScheme: ColorScheme? {
        switch selectedTheme {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

enum ThemeMode: String, CaseIterable {
    case light
    case dark
    case system
    
    var themeName: String {
        switch self {
        case .light: "Light"
        case .dark: "Dark"
        case .system: "System"
        }
    }
    
    var iconName: String {
        switch self {
        case .light: "sun.max.fill"
        case .dark: "moon.fill"
        case .system: "circle.lefthalf.filled"
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
