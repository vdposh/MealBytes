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
    let rdiViewModel: RdiViewModelProtocol
    let customIntakeViewModel: CustomIntakeViewModelProtocol
    
    init(
        mainViewModel: MainViewModelProtocol,
        macrosIntakeViewModel: MacrosIntakeViewModelProtocol,
        rdiViewModel: RdiViewModelProtocol,
        customIntakeViewModel: CustomIntakeViewModelProtocol
    ) {
        self.mainViewModel = mainViewModel
        self.macrosIntakeViewModel = macrosIntakeViewModel
        self.rdiViewModel = rdiViewModel
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
        
        async let rdiTask: () = rdiViewModel.loadRdiView()
        async let macrosIntakeTask: () = macrosIntakeViewModel
            .loadMacrosIntakeView()
        async let customIntakeTask: () = customIntakeViewModel
            .loadCustomIntake()
        
        _ = await (rdiTask, macrosIntakeTask, customIntakeTask)
        
        await MainActor.run {
            conditionallyClearGoalsView()
            isLoading = false
            isDataLoaded = true
        }
    }
    
    func conditionallyClearGoalsView() {
        macrosIntakeViewModel.conditionallyClearMacrosIntake()
        rdiViewModel.conditionallyClearRdi()
        customIntakeViewModel.conditionallyClearCustomIntake()
    }
    
    func clearGoalsView() {
        macrosIntakeViewModel.clearMacrosIntake()
        rdiViewModel.clearRdi()
        customIntakeViewModel.clearCustomIntake()
    }
    
    // MARK: - Text
    func displayState(for source: IntakeSourceType) -> IntakeDisplayState {
        let isActive = self.isActive(source)
        let text: String
        
        switch source {
        case .rdiView: text = rdiViewModel.rdiText
        case .macrosIntakeView: text = macrosIntakeViewModel.macrosIntakeText
        case .customView: text = customIntakeViewModel.customIntakeText
        }
        
        return IntakeDisplayState(
            text: text,
            color: isActive ? .accent : .secondary,
            weight: isActive ? .medium : .regular,
            icon: isActive ? "person.fill" : "person"
        )
    }
    
    func isActive(_ source: IntakeSourceType) -> Bool {
        switch source {
        case .rdiView:
            return currentIntakeSource == source &&
            rdiViewModel.rdiText != "Fill in the data"
        case .macrosIntakeView:
            return currentIntakeSource == source &&
            macrosIntakeViewModel.macrosIntakeText != "Fill in the data"
        case .customView:
            return currentIntakeSource == source &&
            customIntakeViewModel.customIntakeText != "Fill in the data"
        }
    }
    
    var currentIntakeSource: IntakeSourceType {
        IntakeSourceType(rawValue: mainViewModel.intakeSource) ?? .rdiView
    }
    
    enum IntakeSourceType: String {
        case rdiView
        case macrosIntakeView
        case customView
    }
}

extension GoalsViewModel: GoalsViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}
