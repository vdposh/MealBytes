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
                .receive(on: RunLoop.main)
                .sink { [weak self] _ in
                    self?.updateSelectedValid()
                }
                .store(in: &cancellables)
        }
        
        if let custom = customIntakeViewModel as? CustomIntakeViewModel {
            custom.$isValid
                .receive(on: RunLoop.main)
                .sink { [weak self] _ in
                    self?.updateSelectedValid()
                }
                .store(in: &cancellables)
        }
        
        if let personal = personalIntakeViewModel as? PersonalIntakeViewModel {
            personal.$isValid
                .receive(on: RunLoop.main)
                .sink { [weak self] _ in
                    self?.updateSelectedValid()
                }
                .store(in: &cancellables)
        }
        
        $selectedIntakeSource
            .receive(on: RunLoop.main)
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
    func saveSelected() async {
        switch selectedIntakeSource {
        case .personal:
            await personalIntakeViewModel.savePersonalIntakeView()
        case .macros:
            await macrosIntakeViewModel.saveMacrosIntakeView()
        case .custom:
            await customIntakeViewModel.saveCustomIntakeView()
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

enum IntakeSource: String, CaseIterable {
    case personal = "personalIntakeView"
    case macros = "macrosIntakeView"
    case custom = "customView"
    
    var title: String {
        switch self {
        case .personal: return "Personal"
        case .macros: return "Macros"
        case .custom: return "Custom"
        }
    }
    
    var description: String {
        switch self {
        case .personal:
            return "Based on body parameters"
        case .macros:
            return "Calculated from macronutrients"
        case .custom:
            return "Direct entry"
        }
    }
}

extension GoalsViewModel: GoalsViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}
