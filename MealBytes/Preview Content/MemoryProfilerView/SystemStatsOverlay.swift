//
//  SystemStatsOverlay.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/09/2025.
//

import SwiftUI

struct SystemStatsOverlay: View {
    var body: some View {
#if DEBUG
        VStack {
            SystemStatsView()
                .background(.ultraThickMaterial.opacity(0.8))
                .cornerRadius(12)
        }
        .allowsHitTesting(false)
#else
        EmptyView()
#endif
    }
}
