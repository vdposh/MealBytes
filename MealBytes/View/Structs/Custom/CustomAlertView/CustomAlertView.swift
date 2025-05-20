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
    var weight: Font.Weight = .bold
    var foregroundColor: Color = .customGreen.opacity(0.85)
    var backgroundFill: Color = .customGreen.opacity(0.15)
    
    var body: some View {
        if isVisible {
            HStack {
                Image(systemName: iconName)
                    .fontWeight(weight)
                    .symbolEffect(.bounce, options: .nonRepeating)
                Text(message)
                    .font(.callout)
                    .fontWeight(.medium)
            }
            .foregroundColor(foregroundColor)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(
                Rectangle()
                    .fill(backgroundFill)
                    .background(.bar)
            )
            .cornerRadius(15)
            .frame(
                maxHeight: .infinity,
                alignment: .bottom
            )
            .padding(.bottom, 60)
            .allowsHitTesting(false)
            .task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeOut(duration: 0.6)) {
                        isVisible = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MainView(mainViewModel: MainViewModel())
    }
}

#Preview {
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel()
    )
}

#Preview {
    NavigationStack {
        SearchView(
            searchViewModel: SearchViewModel(mainViewModel: MainViewModel()),
            mealType: .breakfast
        )
    }
}
