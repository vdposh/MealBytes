//
//  LoadingView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/03/2025.
//

import SwiftUI

struct LoadingView: View {
    var showLabel: Bool = false
    
    var body: some View {
        HStack {
            ProgressView()
                .progressViewStyle(
                    CircularProgressViewStyle(tint: .accentColor)
                )
            
            if showLabel {
                Text("Loading...")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
