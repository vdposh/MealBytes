//
//  ActionButtonView.swift
//  MealBytes
//
//  Created by Porshe on 13/03/2025.
//

import SwiftUI

struct ActionButtonView: View {
    let title: String
    let action: () -> Void
    let backgroundColor: Color
    var isEnabled: Bool = true
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundColor(.white)
                .font(.headline)
                .lineLimit(1)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

//
//  LoginButtonView.swift
//  MealBytes
//
//  Created by Porshe on 08/04/2025.
//

import SwiftUI

struct LoginButtonView: View {
    let title: String
    let action: () -> Void
    let backgroundColor: Color
    var isEnabled: Bool = true
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: {
            if isEnabled && !isLoading {
                action()
            }
        }) {
            if isLoading {
                // Отображение индикатора загрузки вместо текста
                LoadingView()
            } else {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(backgroundColor)
                    .foregroundColor(.white)
                    .font(.headline)
                    .lineLimit(1)
                    .cornerRadius(12)
            }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled || isLoading) // Кнопка отключается, если идёт загрузка
    }
}
