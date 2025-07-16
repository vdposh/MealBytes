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
    func rdiText() -> String {
        rdiViewModel.text(for: rdiViewModel.calculatedRdi)
    }
    
    func dailyIntakeText() -> String {
        dailyIntakeViewModel.text(for: dailyIntakeViewModel.calories)
    }
    
    var currentIntakeSource: IntakeSourceType {
        IntakeSourceType(rawValue: mainViewModel.intakeSource) ?? .rdiView
    }
    
    func isActive(_ source: IntakeSourceType) -> Bool {
        switch source {
        case .rdiView:
            return currentIntakeSource == source &&
            rdiText() != "Fill in the data"
        case .dailyIntakeView:
            return currentIntakeSource == source &&
            dailyIntakeText() != "Fill in the data"
        }
    }
    
    func color(for source: IntakeSourceType) -> Color {
        isActive(source) ? .customGreen : .secondary
    }
    
    func weight(for source: IntakeSourceType) -> Font.Weight {
        isActive(source) ? .medium : .regular
    }
    
    func icon(for source: IntakeSourceType) -> String {
        isActive(source) ? "person.fill" : "person"
    }
}

enum IntakeSourceType: String {
    case rdiView
    case dailyIntakeView
}

#Preview {
    PreviewContentView.contentView
}
