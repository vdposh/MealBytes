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
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThickMaterial.opacity(0.8))
                }
        }
        .allowsHitTesting(false)
#else
        EmptyView()
#endif
    }
}
