//
//  GoalsViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/04/2025.
//

import SwiftUI

final class GoalsViewModel: ObservableObject {
    @Published var uniqueId = UUID()
    @Published var isDataLoaded: Bool = false
    
    private let mainViewModel: MainViewModelProtocol
    let rdiViewModel: RdiViewModel
    let dailyIntakeViewModel: DailyIntakeViewModel
    
    init(mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
        self.rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)
        self.dailyIntakeViewModel = DailyIntakeViewModel(
            mainViewModel: mainViewModel
        )
    }
    
    // MARK: - Load Data
    func loadGoalsData() async {
        await MainActor.run {
            uniqueId = UUID()
            isDataLoaded = false
        }
        
        async let rdiTask: () = rdiViewModel.loadRdiView()
        async let dailyIntakeTask: () = dailyIntakeViewModel
            .loadDailyIntakeView()
        
        _ = await (rdiTask, dailyIntakeTask)
        
        await MainActor.run {
            isDataLoaded = true
        }
    }
    
    // MARK: - Text
    func displayState(for source: IntakeSourceType) -> IntakeDisplayState {
        let isActive = self.isActive(source)
        let text: String
        switch source {
        case .rdiView:
            text = rdiViewModel.rdiText()
        case .dailyIntakeView:
            text = dailyIntakeViewModel.dailyIntakeText()
        }
        
        return IntakeDisplayState(
            text: text,
            color: isActive ? .customGreen : .secondary,
            weight: isActive ? .medium : .regular,
            icon: isActive ? "person.fill" : "person"
        )
    }
    
    func isActive(_ source: IntakeSourceType) -> Bool {
        switch source {
        case .rdiView:
            return currentIntakeSource == source &&
            rdiViewModel.rdiText() != "Fill in the data"
        case .dailyIntakeView:
            return currentIntakeSource == source &&
            dailyIntakeViewModel.dailyIntakeText() != "Fill in the data"
        }
    }
    
    var currentIntakeSource: IntakeSourceType {
        IntakeSourceType(rawValue: mainViewModel.intakeSource) ?? .rdiView
    }
}

enum IntakeSourceType: String {
    case rdiView
    case dailyIntakeView
}

#Preview {
    PreviewContentView.contentView
}
