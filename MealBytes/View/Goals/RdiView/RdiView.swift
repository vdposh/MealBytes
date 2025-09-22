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
        List {
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
        .navigationBarTitle("RDI", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                buildKeyboardToolbar(
                    current: focusedField,
                    ordered: rdiOrder,
                    set: { focusedField = $0 },
                    normalize: rdiViewModel.normalizeInputs
                )
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
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
        .onChange(of: focusedField) {
            rdiViewModel.handleFocusChange(from: focusedField)
        }
        .alert("Error", isPresented: $rdiViewModel.showAlert) {
            Button("OK") {
                rdiViewModel.showAlert = false
            }
        } message: {
            Text(rdiViewModel.alertMessage)
        }
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
