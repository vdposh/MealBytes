//
//  FoodAddedAlertView.swift
//  MealBytes
//
//  Created by Porshe on 19/05/2025.
//

import SwiftUI

struct FoodAddedAlertView: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        if isVisible {
            HStack {
                Image(systemName: "checkmark")
                    .fontWeight(.bold)
                Text("Added to Diary")
                    .font(.callout)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.customGreen.opacity(0.85))
            .padding(.vertical)
            .padding(.horizontal, 25)
            .background(
                Rectangle()
                    .fill(Color.customGreen.opacity(0.12))
                    .background(Material.bar)
            )
            .cornerRadius(15)
            .frame(
                maxWidth: .infinity,
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
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel()
    )
}
