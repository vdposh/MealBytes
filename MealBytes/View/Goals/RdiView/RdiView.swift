//
//  RdiView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

struct RdiView: View {
    @FocusState private var focusedField: RdiFocus?
    @Environment(\.dismiss) private var dismiss
    
    private let rdiOrder: [RdiFocus] = [.age, .weight, .height]
    
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        rdiViewContentBody
            .navigationBarTitle("RDI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                rdiViewToolbar
            }
            .alert(isPresented: $rdiViewModel.showAlert) {
                rdiViewAlert
            }
            .onChange(of: focusedField) {
                rdiViewModel.handleFocusChange(from: focusedField)
            }
    }
    
    private var rdiViewContentBody: some View {
        Form {
            OverviewRdiSection(rdiViewModel: rdiViewModel)
            GenderSection(rdiViewModel: rdiViewModel)
            ActivitySection(rdiViewModel: rdiViewModel)
            AgeSection(
                focusedField: _focusedField,
                rdiViewModel: rdiViewModel
            )
            WeightSection(
                focusedField: _focusedField,
                rdiViewModel: rdiViewModel
            )
            HeightSection(
                focusedField: _focusedField,
                rdiViewModel: rdiViewModel
            )
        }
    }
    
    @ToolbarContentBuilder
    private var rdiViewToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            buildKeyboardToolbar(
                current: focusedField,
                ordered: rdiOrder,
                set: { focusedField = $0 },
                normalize: rdiViewModel.normalizeInputs
            )
        }
        
        ToolbarItem {
            Button(role: .confirm) {
                if rdiViewModel.handleSave() {
                    Task {
                        await rdiViewModel.saveRdiView()
                    }
                    dismiss()
                }
                
                focusedField = nil
                rdiViewModel.normalizeInputs()
            }
        }
    }
    
    private var rdiViewAlert: Alert {
        Alert(
            title: Text("Error"),
            message: Text(rdiViewModel.alertMessage),
            dismissButton: .default(Text("OK")) {
                rdiViewModel.showAlert = false
            }
        )
    }
}

enum RdiFocus: Hashable {
    case age
    case height
    case weight
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewRdiView.rdiView
}
