//
//  DisclaimerButtonSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 22/07/2025.
//

import SwiftUI

struct DisclaimerButtonSection: View {
    @State private var showDisclaimer = false
    
    var body: some View {
        Section {
            Button("About Daily Intake and Recommendations") {
                showDisclaimer = true
            }
            .font(.subheadline)
            .buttonStyle(.borderless)
            .sheet(isPresented: $showDisclaimer) {
                DisclaimerSheetView()
            }
        }
        .listRowBackground(Color.clear)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    PreviewGoalsView.goalsView
}
