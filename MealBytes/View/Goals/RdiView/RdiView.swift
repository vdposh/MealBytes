//
//  RdiView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

struct RdiView: View {
    @FocusState private var focus: Bool
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        rdiViewContentBody
            .navigationTitle(IntakeSource.personal.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                rdiViewToolbar
            }
            .safeAreaInset(edge: .bottom) {
                DirectionToolbarView(
                    focused: focus,
                    done: {
                        focus = false
                        rdiViewModel.normalizeAge()
                    }
                )
            }
            .ignoresSafeArea(edges: focus ? [] : .bottom)
    }
    
    private var rdiViewContentBody: some View {
        Form {
            OverviewRdiSection(rdiViewModel: rdiViewModel)
            
            ServingTextFieldView(
                text: $rdiViewModel.age,
                stackText: "Age",
                useStackTrailing: true,
                keyboardType: .numberPad,
                inputMode: .integer,
                maxIntegerDigits: 3
            )
            .focused($focus)
            
            GenderSection(rdiViewModel: rdiViewModel)
            ActivitySection(rdiViewModel: rdiViewModel)
            WeightSection(rdiViewModel: rdiViewModel)
            HeightSection(rdiViewModel: rdiViewModel)
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
                
                focus = false
                rdiViewModel.normalizeAge()
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
