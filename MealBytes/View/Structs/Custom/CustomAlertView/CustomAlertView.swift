//
//  FoodAddedAlertView.swift
//  MealBytes
//
//  Created by Porshe on 19/05/2025.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var isVisible: Bool
    var iconName: String = "checkmark"
    var message: String = "Added to Diary"
    var foregroundColor: Color = .customGreen.opacity(0.85)
    var backgroundFill: Color = Color.customGreen.opacity(0.12)
    
    var body: some View {
        if isVisible {
            HStack {
                Image(systemName: iconName)
                    .fontWeight(.bold)
                Text(message)
                    .font(.callout)
                    .fontWeight(.semibold)
            }
            .foregroundColor(foregroundColor)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(
                Rectangle()
                    .fill(backgroundFill)
                    .background(Material.bar)
            )
            .cornerRadius(15)
            .frame(
                maxHeight: .infinity,
                alignment: .bottom
            )
            .padding(.bottom, 40)
            .allowsHitTesting(false)
            .task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        isVisible = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchView(
            searchViewModel: SearchViewModel(mainViewModel: MainViewModel()),
            mealType: .breakfast
        )
    }
}

#Preview {
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel()
    )
}
