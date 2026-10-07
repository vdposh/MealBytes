//
//  AppearanceSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct AppearanceSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Section {
            NavigationLink {
                AppearanceView(themeManager: themeManager)
                    .environmentObject(themeManager)
            } label: {
                LabeledContent {
                    Text(themeManager.selectedTheme.themeName)
                } label: {
                    Text("Appearance")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AppearanceView(themeManager: ThemeManager())
    }
}

#Preview {
    PreviewProfileView.profileView
}

#Preview {
    PreviewContentView.contentView
}
