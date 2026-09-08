//
//  LoadingView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/03/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack {
            ProgressView()
            
            Text("Loading...")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    NavigationStack {
        ResetView()
    }
}
