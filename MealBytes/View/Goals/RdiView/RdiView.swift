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
    
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            if rdiViewModel.isDataLoaded {
                ScrollViewReader { proxy in
                    ScrollView {
                        OverviewSection(rdiViewModel: rdiViewModel)
                        AgeSection(
                            focusedField: _focusedField,
                            rdiViewModel: rdiViewModel
                        )
                        GenderSection(rdiViewModel: rdiViewModel)
                        ActivitySection(rdiViewModel: rdiViewModel)
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
                            HStack(spacing: 0) {
                                if focusedField != nil {
                                    Button {
                                        moveFocus(.up)
                                    } label: {
                                        Image(systemName: "chevron.up")
                                            .foregroundColor(
                                                colorForFocus(
                                                    isActive: canMoveFocus(.up)
                                                )
                                            )
                                    }
                                    .disabled(!canMoveFocus(.up))
                                    
                                    Button {
                                        moveFocus(.down)
                                    } label: {
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(
                                                colorForFocus(
                                                    isActive: canMoveFocus(
                                                        .down
                                                    )
                                                )
                                            )
                                    }
                                    .disabled(!canMoveFocus(.down))
                                }
                            }
                            
                            DoneButtonView {
                                focusedField = nil
                                rdiViewModel.normalizeInputs()
                            }
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
                    .onChange(of: focusedField) {
                        guard let field = focusedField else { return }
                        withAnimation {
                            proxy.scrollTo(field.scrollID,
                                           anchor: field.scrollAnchor)
                        }
                    }
                    .alert("Error", isPresented: $rdiViewModel.showAlert) {
                        Button("OK") {
                            rdiViewModel.showAlert = false
                        }
                    } message: {
                        Text(rdiViewModel.alertMessage)
                    }
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
        guard canMoveFocus(direction) else { return }
        switch direction {
        case .up:
            switch focusedField {
            case .weight: focusedField = .age
            case .height: focusedField = .weight
            default: break
            }
        case .down:
            switch focusedField {
            case .age: focusedField = .weight
            case .weight: focusedField = .height
            default: break
            }
        }
    }
    
    private func canMoveFocus(_ direction: FocusDirection) -> Bool {
        guard let focus = focusedField else { return false }
        switch direction {
        case .up: return focus != .age
        case .down: return focus != .height
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
    
    var scrollID: String {
        switch self {
        case .age: "ageField"
        case .weight: "weightField"
        case .height: "heightField"
        }
    }
    
    var scrollAnchor: UnitPoint {
        switch self {
        case .age: .bottom
        case .weight: .center
        case .height: .top
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    let mainViewModel = MainViewModel()
    let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)
    
    return NavigationStack {
        RdiView(rdiViewModel: rdiViewModel)
    }
}
