//
//  DisclaimerSheetView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/07/2025.
//

import SwiftUI

struct DisclaimerSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    EmptyView()
                } footer: {
                    Text("""
                \(String("Daily Intake and Recommendations".uppercased()))
                
                The daily intake values displayed in MealBytes are an estimate based on your personal input and are not intended as medical advice or dietary recommendations.
                
                Please consult a qualified healthcare professional or registered dietitian before making significant dietary changes or if you have specific medical conditions or nutritional needs. MealBytes does not replace individualized clinical advice.
                """)
                }
            }
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DisclaimerSheetView()
    }
}
