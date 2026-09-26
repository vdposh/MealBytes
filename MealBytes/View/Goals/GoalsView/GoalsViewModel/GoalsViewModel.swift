//
//  GoalsViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/04/2025.
//

import SwiftUI
import Combine

protocol GoalsViewModelProtocol {
    func clearGoalsView()
    func loadGoalsData() async
}

final class GoalsViewModel: ObservableObject {
    @Published var selectedIntakeSource: IntakeSource = .personal
    @Published var isSelectedValid: Bool = false
    
    private let mainViewModel: MainViewModelProtocol
    let macrosIntakeViewModel: MacrosIntakeViewModelProtocol
    let personalIntakeViewModel: PersonalIntakeViewModelProtocol
    let customIntakeViewModel: CustomIntakeViewModelProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        mainViewModel: MainViewModelProtocol,
        macrosIntakeViewModel: MacrosIntakeViewModelProtocol,
        personalIntakeViewModel: PersonalIntakeViewModelProtocol,
        customIntakeViewModel: CustomIntakeViewModelProtocol
    ) {
        self.mainViewModel = mainViewModel
        self.macrosIntakeViewModel = macrosIntakeViewModel
        self.personalIntakeViewModel = personalIntakeViewModel
        self.customIntakeViewModel = customIntakeViewModel
        
        setupValidation()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Load Goals Data
    func loadGoalsData() async {
        async let personalIntakeTask: () = personalIntakeViewModel
            .loadPersonalIntakeView()
        async let macrosIntakeTask: () = macrosIntakeViewModel
            .loadMacrosIntakeView()
        async let customIntakeTask: () = customIntakeViewModel
            .loadCustomIntake()
        
        _ = await (personalIntakeTask, macrosIntakeTask, customIntakeTask)
        
        await MainActor.run {
            selectedIntakeSource = IntakeSource(
                rawValue: mainViewModel.intakeSource
            ) ?? .personal
            
            conditionallyClearGoalsView()
        }
    }
    
    func conditionallyClearGoalsView() {
        macrosIntakeViewModel.conditionallyClearMacrosIntake()
        personalIntakeViewModel.conditionallyClearPersonalIntake()
        customIntakeViewModel.conditionallyClearCustomIntake()
    }
    
    func clearGoalsView() {
        macrosIntakeViewModel.clearMacrosIntake()
        personalIntakeViewModel.clearPersonalIntake()
        customIntakeViewModel.clearCustomIntake()
    }
    
    // MARK: - Calculation
    private func setupValidation() {
        if let macros = macrosIntakeViewModel as? MacrosIntakeViewModel {
            macros.$isValid
                .sink { [weak self] _ in
                    self?.updateSelectedValid()
                }
                .store(in: &cancellables)
        }
        
        if let custom = customIntakeViewModel as? CustomIntakeViewModel {
            custom.$isValid
                .sink { [weak self] _ in
                    self?.updateSelectedValid()
                }
                .store(in: &cancellables)
        }
        
        if let personal = personalIntakeViewModel as? PersonalIntakeViewModel {
            personal.$isValid
                .sink { [weak self] _ in
                    self?.updateSelectedValid()
                }
                .store(in: &cancellables)
        }
        
        $selectedIntakeSource
            .sink { [weak self] _ in
                self?.updateSelectedValid()
            }
            .store(in: &cancellables)
    }
    
    private func updateSelectedValid() {
        switch selectedIntakeSource {
        case .personal:
            isSelectedValid = personalIntakeViewModel.isValid
        case .macros:
            isSelectedValid = macrosIntakeViewModel.isValid
        case .custom:
            isSelectedValid = customIntakeViewModel.isValid
        }
    }
    
    func selectSource(_ source: IntakeSource) {
        selectedIntakeSource = source
        updateSelectedValid()
    }
    
    // MARK: - UI Helper
    @ViewBuilder
    func goalsViewBuilder(
        for source: IntakeSource,
        customFocus: FocusState<CustomIntakeFocus?>.Binding,
        macrosFocus: FocusState<MacronutrientsFocus?>.Binding
    ) -> some View {
        switch source {
        case .personal:
            if let personalIntakeViewModel = personalIntakeViewModel
                as? PersonalIntakeViewModel {
                PersonalIntakeView(
                    personalIntakeViewModel: personalIntakeViewModel
                )
            }
        case .macros:
            if let macrosIntakeViewModel = macrosIntakeViewModel
                as? MacrosIntakeViewModel {
                MacrosIntakeView(
                    focus: macrosFocus,
                    macrosIntakeViewModel: macrosIntakeViewModel
                )
            }
        case .custom:
            if let customIntakeViewModel = customIntakeViewModel
                as? CustomIntakeViewModel {
                CustomIntakeView(
                    customIntakeViewModel: customIntakeViewModel,
                    focus: customFocus
                )
            }
        }
    }
    
    func saveSelected() async {
        switch selectedIntakeSource {
        case .personal:
            await personalIntakeViewModel.savePersonalIntakeView()
        case .macros:
            await macrosIntakeViewModel.saveMacrosIntakeView()
        case .custom:
            await customIntakeViewModel.saveCustomIntake()
        }
    }
    
    func normalizeSelected() {
        switch selectedIntakeSource {
        case .personal:
            break
        case .macros:
            macrosIntakeViewModel.normalizeInputs()
        case .custom:
            customIntakeViewModel.normalizeInputs()
        }
    }
}

extension GoalsViewModel: GoalsViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}
