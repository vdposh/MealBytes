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
            .navigationTitle("RDI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                rdiViewToolbar
            }
            .safeAreaInset(edge: .bottom) {
                if focus {
                    KeyboardToolbarView(
                        done: {
                            focus = false
                            rdiViewModel.normalizeAge()
                        }
                    )
                }
            }
            .alert(isPresented: $rdiViewModel.showAlert) {
                rdiViewAlert
            }
    }
    
    private var rdiViewContentBody: some View {
        Form {
            OverviewRdiSection(rdiViewModel: rdiViewModel)
            AgeSection(focus: $focus, rdiViewModel: rdiViewModel)
            GenderSection(rdiViewModel: rdiViewModel)
            ActivitySection(rdiViewModel: rdiViewModel)
            WeightSection(rdiViewModel: rdiViewModel)
            HeightSection(rdiViewModel: rdiViewModel)
        }
    }
    
    @ToolbarContentBuilder
    private var rdiViewToolbar: some ToolbarContent {
        ToolbarItem {
            Button(role: .confirm) {
                if rdiViewModel.handleRdiSave() {
                    Task {
                        await rdiViewModel.saveRdiView()
                    }
                    
                    dismiss()
                }
                
                focus = false
                rdiViewModel.normalizeAge()
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

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewRdiView.rdiView
}
