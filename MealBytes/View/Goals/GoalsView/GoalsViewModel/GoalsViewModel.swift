//
//  GoalsViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/04/2025.
//

import SwiftUI

protocol GoalsViewModelProtocol {
    func clearGoalsView()
}

final class GoalsViewModel: ObservableObject {
    @Published var selectedIntakeSource: IntakeSource = .personal
    @Published var uniqueId = UUID()
    @Published var isDataLoaded: Bool = false
    @Published var isLoading: Bool = false
    
    private let mainViewModel: MainViewModelProtocol
    let macrosIntakeViewModel: MacrosIntakeViewModelProtocol
    let personalIntakeViewModel: PersonalIntakeViewModelProtocol
    let customIntakeViewModel: CustomIntakeViewModelProtocol
    
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
    }
    
    // MARK: - Load Goals Data
    func loadGoalsData() async {
        guard !isLoading else { return }
        
        await MainActor.run {
            uniqueId = UUID()
            isLoading = true
            isDataLoaded = false
        }
        
        async let personalIntakeTask: () = personalIntakeViewModel
            .loadPersonalIntakeView()
        async let macrosIntakeTask: () = macrosIntakeViewModel
            .loadMacrosIntakeView()
        async let customIntakeTask: () = customIntakeViewModel
            .loadCustomIntake()
        
        _ = await (personalIntakeTask, macrosIntakeTask, customIntakeTask)
        
        await MainActor.run {
            conditionallyClearGoalsView()
            isLoading = false
            isDataLoaded = true
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
    
    // MARK: - Text
    func displayState(for source: IntakeSourceType) -> IntakeDisplayState {
        let isActive = self.isActive(source)
        let text: String
        
        switch source {
        case .personalIntakeView: text = personalIntakeViewModel
                .personalIntakeText
        case .macrosIntakeView: text = macrosIntakeViewModel.macrosIntakeText
        case .customView: text = customIntakeViewModel.customIntakeText
        }
        
        return IntakeDisplayState(
            text: text,
            color: isActive ? .accent : .secondary,
            icon: isActive ? "person.fill" : "person"
        )
    }
    
    func isActive(_ source: IntakeSourceType) -> Bool {
        switch source {
        case .personalIntakeView:
            return currentIntakeSource == source &&
            personalIntakeViewModel.personalIntakeText != "Fill in the data"
        case .macrosIntakeView:
            return currentIntakeSource == source &&
            macrosIntakeViewModel.macrosIntakeText != "Fill in the data"
        case .customView:
            return currentIntakeSource == source &&
            customIntakeViewModel.customIntakeText != "Fill in the data"
        }
    }
    
    var currentIntakeSource: IntakeSourceType {
        IntakeSourceType(
            rawValue: mainViewModel.intakeSource
        ) ?? .personalIntakeView
    }
    
    enum IntakeSourceType: String {
        case personalIntakeView
        case macrosIntakeView
        case customView
    }
}

extension GoalsViewModel: GoalsViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}
