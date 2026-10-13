//
//  Logger+Extensions.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13.10.2026.
//

import OSLog

extension Logger {
    static let main = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "MealBytes",
        category: "MainViewModel"
    )
    
    static let search = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "MealBytes",
        category: "SearchViewModel"
    )
    
    static let goals = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "MealBytes",
        category: "GoalsViewModel"
    )
    
    static let profile = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "MealBytes",
        category: "ProfileViewModel"
    )
}
