//
//  SectionStyle.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct SectionStyleContainer<Content: View>: View {
    var mainContent: Content
    var secondaryContent: AnyView?
    var layout: SectionCardLayout
    var title: String?
    var description: String?
    var useUppercasedTitle: Bool = true
    var useWideTrailingPadding: Bool = false
    var hasBottomPadding: Bool = true
    var hasTopTextPadding: Bool = true
    var useLargeCornerRadius: Bool = false
    
    init(
        @ViewBuilder mainContent: () -> Content,
        @ViewBuilder secondaryContent: () -> AnyView? = { nil },
        layout: SectionCardLayout = .textStyle,
        title: String? = nil,
        description: String? = nil,
        useUppercasedTitle: Bool = true,
        useWideTrailingPadding: Bool = false,
        hasBottomPadding: Bool = true,
        hasTopTextPadding: Bool = true,
        useLargeCornerRadius: Bool = false
    ) {
        self.mainContent = mainContent()
        self.secondaryContent = secondaryContent()
        self.layout = layout
        self.title = title
        self.description = description
        self.useUppercasedTitle = useUppercasedTitle
        self.useWideTrailingPadding = useWideTrailingPadding
        self.hasBottomPadding = hasBottomPadding
        self.hasTopTextPadding = hasTopTextPadding
        self.useLargeCornerRadius = useLargeCornerRadius
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let title {
                Text(useUppercasedTitle ? title.uppercased() : title)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 40)
            }
            
            switch layout {
            case .pickerStyle:
                mainContent
                    .padding(.vertical, 6)
                    .padding(.leading, 20)
                    .padding(.trailing, useWideTrailingPadding ? 20 : 10)
                    .background(
                        Color(uiColor: .secondarySystemGroupedBackground)
                    )
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
            case .pickerUnitStyle:
                VStack {
                    mainContent
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                    
                    if let secondary = secondaryContent {
                        secondary
                            .padding(.leading, 20)
                            .padding(.trailing, 10)
                            .padding(.top, 2)
                            .padding(.bottom, 10)
                    }
                }
                .background(
                    Color(uiColor: .secondarySystemGroupedBackground)
                )
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
            case .textStyle:
                mainContent
                    .padding(.horizontal, 20)
                    .padding(.top, hasTopTextPadding ? 12 : 5)
                    .padding(.bottom)
                    .background(
                        Color(uiColor: .secondarySystemGroupedBackground)
                    )
                    .cornerRadius(useLargeCornerRadius ? 12 : 10)
                    .padding(.horizontal, 20)
                
            case .resultRdiStyle:
                mainContent
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.horizontal, 40)
            }
            
            if let description {
                Text(description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 40)
            }
        }
        .padding(.bottom, hasBottomPadding ? 25 : 0)
    }
}

enum SectionCardLayout {
    case pickerStyle
    case pickerUnitStyle
    case textStyle
    case resultRdiStyle
}

#Preview {
    let loginViewModel = LoginViewModel()
    let mainViewModel = MainViewModel()
    let themeManager = ThemeManager()
    
    NavigationStack {
        ProfileView(
            profileViewModel: ProfileViewModel(
                loginViewModel: loginViewModel,
                mainViewModel: mainViewModel
            )
        )
        .environmentObject(themeManager)
    }
}
