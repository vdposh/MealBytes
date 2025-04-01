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
            }
        } description: {
            switch error {
            case .noBookmarks:
                Text("Add your favorite dishes to bookmarks, and they'll appear here.")
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
