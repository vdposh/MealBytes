//
//  ThemePickerSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct ThemePickerSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Section {
            NavigationLink {
                ThemePickerView(themeManager: themeManager)
                    .environmentObject(themeManager)
            } label: {
                LabeledContent {
                    Text(themeManager.selectedTheme.themeName)
                } label: {
                    Text("App Theme")
                }
            }
        } footer: {
            Text("Customize app appearance.")
        }
    }
}

#Preview {
    NavigationStack {
        ThemePickerView(themeManager: ThemeManager())
    }
}

#Preview {
    PreviewProfileView.profileView
}

#Preview {
    PreviewContentView.contentView
}
