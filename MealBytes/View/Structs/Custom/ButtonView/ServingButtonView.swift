//
//  ServingButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/03/2025.
//

import SwiftUI

struct ServingButtonView: View {
    @Binding var showActionSheet: Bool
    let title: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 10, height: 6)
                }
                .frame(height: 35)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.secondary),
                    alignment: .bottom
                )
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    let loginViewModel = LoginViewModel()
    let mainViewModel = MainViewModel()
    let goalsViewModel = GoalsViewModel(mainViewModel: mainViewModel)
    
    ContentView(
        loginViewModel: loginViewModel,
        mainViewModel: mainViewModel,
        goalsViewModel: goalsViewModel
    )
    .environmentObject(ThemeManager())
}
