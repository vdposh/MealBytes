//
//  View+Extensions.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 22/03/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func contentUnavailableView(
        for error: AppError,
        mealType: MealType,
        query: String = "",
        action: @escaping () -> Void
    ) -> some View {
        ContentUnavailableView {
            switch error {
            case .network, .networkRefresh:
                Label("Network error", systemImage: "wifi.slash")
                    .symbolEffect(.pulse)
                
            case .decoding:
                Label(
                    "Data processing issue",
                    systemImage: "exclamationmark.triangle"
                )
                .symbolEffect(.rotate, options: .nonRepeating)
                
            case .results:
                ContentUnavailableView.search(text: query)
                
            case .noEntries:
                Label(
                    "No \(mealType.rawValue) entries yet",
                    systemImage: "fork.knife"
                )
                
            case .noBookmarks:
                Label(
                    "No \(mealType.rawValue) bookmarks yet",
                    systemImage: "bookmark"
                )
                
            case .noRecent:
                Label(
                    "No \(mealType.rawValue) recent logs yet",
                    systemImage: "clock"
                )
                
            case .disconnected:
                Label("Disconnected", systemImage: "person.fill.questionmark")
                    .symbolEffect(.breathe)
            }
        } description: {
            switch error {
            case .noEntries:
                Text("Search for foods and add them to the diary or bookmarks.")
            case .noBookmarks:
                Text("Add favorite foods to bookmarks and they will appear here.")
            case .noRecent:
                Text("Foods added to the diary appear here unless bookmarked.")
            case .disconnected:
                Text("Account disconnected. Log out and log back in to restore data sync.")
            default:
                Text(error.errorDescription)
            }
        } actions: {
            switch error {
            case .networkRefresh:
                Button {
                    action()
                } label: {
                    Text("Try Again")
                        .fontWeight(.medium)
                        .padding(6)
                }
                .buttonStyle(.glassProminent)
            default:
                EmptyView()
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
