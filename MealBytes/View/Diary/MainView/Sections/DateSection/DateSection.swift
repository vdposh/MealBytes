//
//  DateSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19.05.2026.
//

import SwiftUI

struct DateSection: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            EmptyView()
        } header: {
            DateCollectionView(
                mainViewModel: mainViewModel,
                dateSectionWeeks: mainViewModel.dateSectionWeeks,
                onDateSelected: { date in
                    mainViewModel.date = date
                },
                onLoadMore: { direction in
                    mainViewModel.loadMoreWeeks(direction: direction)
                }
            )
            .frame(height: 65)
        }
        .listRowInsets(
            EdgeInsets(top: 8, leading: -16, bottom: 0, trailing: -16)
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
