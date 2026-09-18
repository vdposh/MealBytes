//
//  RdiView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

struct RdiView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        rdiViewContentBody
            .navigationTitle(IntakeSource.personal.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                rdiViewToolbar
            }
    }
    
    private var rdiViewContentBody: some View {
        Form {
            OverviewRdiSection(rdiViewModel: rdiViewModel)
            BodyProfileSection(rdiViewModel: rdiViewModel)
            WeightSection(rdiViewModel: rdiViewModel)
            HeightSection(rdiViewModel: rdiViewModel)
            ActivitySection(rdiViewModel: rdiViewModel)
            WeightGoalSelection(rdiViewModel: rdiViewModel)
        }
    }
    
    @ToolbarContentBuilder
    private var rdiViewToolbar: some ToolbarContent {
        ToolbarItem {
            Button(role: .confirm) {
                Task {
                    await rdiViewModel.saveRdiView()
                }
                
                dismiss()
            }
            .disabled(!rdiViewModel.isValid)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewRdiView.rdiView
}
