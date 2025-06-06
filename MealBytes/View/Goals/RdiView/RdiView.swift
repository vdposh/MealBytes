//
//  RdiView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

struct RdiView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: RdiFocus?
    @StateObject private var rdiViewModel = RdiViewModel()
    
    var body: some View {
        ZStack {
            if rdiViewModel.isDataLoaded {
                List {
                    OverviewSection(rdiViewModel: rdiViewModel)
                    BasicInfoSection(
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
                .scrollDismissesKeyboard(.never)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        HStack(spacing: 0) {
                            Button {
                                moveFocus(.up)
                            } label: {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(colorForFocus(
                                        isActive: canMoveFocus(.up)))
                            }
                            .disabled(!canMoveFocus(.up))
                            
                            Button {
                                moveFocus(.down)
                            } label: {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(colorForFocus(
                                        isActive: canMoveFocus(.down)))
                            }
                            .disabled(!canMoveFocus(.down))
                        }
                        
                        Button("Done") {
                            focusedField = nil
                        }
                        .font(.headline)
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if rdiViewModel.handleSave() {
                                Task {
                                    await rdiViewModel.saveRdiView()
                                }
                                dismiss()
                            }
                        }
                    }
                }
                .alert("Error", isPresented: $rdiViewModel.showAlert) {
                    Button("OK", role: .none) {
                        rdiViewModel.showAlert = false
                    }
                } message: {
                    Text(rdiViewModel.alertMessage)
                }
                .task {
                    await rdiViewModel.loadRdiView()
                }
            } else {
                LoadingView()
                    .task {
                        await rdiViewModel.loadRdiView()
                    }
            }
        }
    }
    
    // MARK: - Keyboard
    private func moveFocus(_ direction: FocusDirection) {
        guard let currentFocus = focusedField else { return }
        switch direction {
        case .up:
            switch currentFocus {
            case .weight:
                focusedField = .age
            case .height:
                focusedField = .weight
            default:
                break
            }
        case .down:
            switch currentFocus {
            case .age:
                focusedField = .weight
            case .weight:
                focusedField = .height
            default:
                break
            }
        }
    }
    
    private func canMoveFocus(_ direction: FocusDirection) -> Bool {
        guard let currentFocus = focusedField else { return false }
        switch direction {
        case .up:
            return currentFocus != .age
        case .down:
            return currentFocus != .height
        }
    }
    
    private enum FocusDirection {
        case up
        case down
    }
    
    private func colorForFocus(isActive: Bool) -> Color {
        isActive ? .customGreen : .secondary
    }
}

enum RdiFocus: Hashable {
    case age
    case height
    case weight
}

#Preview {
    NavigationStack {
        RdiView()
    }
}
