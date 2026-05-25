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
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(
                        Array(mainViewModel.dateSectionWeeks.enumerated()),
                        id: \.offset
                    ) { index, week in
                        HStack(spacing: 5) {
                            ForEach(week, id: \.self) { date in
                                Button {
                                    mainViewModel.date = date
                                } label: {
                                    DateView(
                                        date: date,
                                        isToday: mainViewModel.calendar
                                            .isDate(date, inSameDayAs: Date()),
                                        isSelected: mainViewModel.calendar
                                            .isDate(
                                                date,
                                                inSameDayAs: mainViewModel.date
                                            ),
                                        mainViewModel: mainViewModel
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .containerRelativeFrame(.horizontal)
                        .task {
                            checkAndLoadMore(at: index)
                        }
                    }
                }
                .id(mainViewModel.uniqueId)
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $mainViewModel.dateSectionScrollPosition)
            .scrollIndicators(.hidden)
        }
        .listRowInsets(
            EdgeInsets(top: 20, leading: -16, bottom: 0, trailing: -16)
        )
        .onChange(of: mainViewModel.date) {
            mainViewModel.updateDateSection()
        }
    }
    
    private func checkAndLoadMore(at index: Int) {
        guard !mainViewModel.isLoadingMore else { return }
        
        if index == 0 {
            mainViewModel.isLoadingMore = true
            loadMoreWeeks(direction: .backward)
        } else if index == mainViewModel.dateSectionWeeks.count - 1 {
            mainViewModel.isLoadingMore = true
            loadMoreWeeks(direction: .forward)
        }
    }
    
    private func loadMoreWeeks(direction: DirectionDateView) {
        guard let result = mainViewModel.loadMoreWeeks(
            currentWeeks: mainViewModel.dateSectionWeeks,
            direction: direction
        ) else {
            mainViewModel.isLoadingMore = false
            return
        }
        
        if direction == .backward {
            mainViewModel.dateSectionWeeks.insert(result.newWeek, at: 0)
            if let currentPos = mainViewModel.dateSectionScrollPosition {
                mainViewModel
                    .dateSectionScrollPosition = currentPos + result.offset
            }
        } else {
            mainViewModel.dateSectionWeeks.append(result.newWeek)
        }
        
        mainViewModel.uniqueId = UUID()
        mainViewModel.isLoadingMore = false
    }
}

#Preview {
    PreviewContentView.contentView
}
