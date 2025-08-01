//
//  LoadingProfileView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/07/2025.
//

import SwiftUI

struct LoadingProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isPasswordChanging: Bool
    
    private var backgroundColor: Color {
        if colorScheme == .dark {
            Color(.darkText)
                .opacity(0.4)
        } else {
            Color.primary
                .opacity(0.2)
        }
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            if isPasswordChanging {
                VStack {
                    Text("Loading")
                        .font(.headline)
                    
                    Text("Updating password...")
                        .font(.footnote)
                        .padding(.bottom, 14)
                    
                    Divider()
                    
                    LoadingView()
                        .padding(.top, 4)
                }
                .multilineTextAlignment(.center)
                .lineSpacing(-2)
                .padding(.top, 18)
                .padding(.bottom, 12)
                .background(.regularMaterial)
                .cornerRadius(12)
                .frame(width: 270)
            }
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    PreviewContentView.contentView
}
