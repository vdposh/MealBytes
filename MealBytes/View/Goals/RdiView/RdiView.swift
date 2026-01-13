//
//  RdiView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

struct RdiView: View {
    @FocusState private var rdiFocused: RdiFocus?
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
            .onChange(of: rdiFocused) {
                rdiViewModel.handleRdiFocusChange(from: rdiFocused)
            }
    }
    
    private var rdiViewContentBody: some View {
        Form {
            OverviewRdiSection(rdiViewModel: rdiViewModel)
            GenderSection(rdiViewModel: rdiViewModel)
            ActivitySection(rdiViewModel: rdiViewModel)
            AgeSection(
                focus: _rdiFocused,
                rdiViewModel: rdiViewModel
            )
            WeightSection(
                focus: _rdiFocused,
                rdiViewModel: rdiViewModel
            )
            HeightSection(
                focus: _rdiFocused,
                rdiViewModel: rdiViewModel
            )
        }
    }
    
    @ToolbarContentBuilder
    private var rdiViewToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            buildKeyboardToolbar(
                current: rdiFocused,
                ordered: rdiOrder,
                set: { rdiFocused = $0 },
                normalize: rdiViewModel.normalizeInputs
            )
        }
        
        ToolbarItem {
            Button(role: .confirm) {
                if rdiViewModel.handleRdiSave() {
                    Task {
                        await rdiViewModel.saveRdiView()
                    }
                    
                    dismiss()
                }
                
                rdiFocused = nil
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
