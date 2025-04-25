//
//  View+Extensions.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func contentUnavailableView(
        for error: AppError,
        query: String = "",
        action: @escaping () -> Void
    ) -> some View {
        ContentUnavailableView {
            switch error {
            case .network:
                Label {
                    Text("Network error")
                } icon: {
                    Image(systemName: "wifi.slash")
                }
                .symbolEffect(.pulse)
            case .decoding:
                Label {
                    Text("Data processing issue")
                } icon: {
                    Image(systemName: "exclamationmark.triangle")
                }
                .symbolEffect(.rotate, options: .nonRepeating)
            case .results:
                ContentUnavailableView.search(text: query)
            case .noBookmarks:
                Label {
                    Text("No bookmarks yet")
                } icon: {
                    Image(systemName: "bookmark")
                }
            case .disconnected:
                Label {
                    Text("Disconnected")
                } icon: {
                    Image(systemName: "person.fill.questionmark")
                }
                .symbolEffect(.breathe)
            }
        } description: {
            switch error {
            case .noBookmarks:
                Text("Mark favorite food items as bookmarks, and they’ll be displayed here.")
            case .disconnected:
                Text("Account disconnected. Log out and log back in to restore data sync.")
            default:
                Text(error.errorDescription)
            }
        } actions: {
            switch error {
            case .network:
                Button("Refresh", action: action)
            default:
                EmptyView()
            }
        }
    }
}
