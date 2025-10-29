//
//  OverviewIntake.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/10/2025.
//

import SwiftUI

struct OverviewIntake: View {
    let valueText: String
    let color: Color
    let footerText: String
    var showValue: Bool = true
    
    var body: some View {
        Section {
        } footer: {
            Text(footerText)
        }
        
        if showValue {
            Section {
                Text(valueText)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
            .listSectionMargins(.vertical, 0)
            .listRowBackground(Color.clear)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
