//
//  DateSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19.05.2026.
//

import SwiftUI

struct DateSection: View {
    @State private var weeks: [[Date]] = []
    @State private var scrollPosition: Int?
    @State private var isLoadingMore = false
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            EmptyView()
        } header: {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(
                        Array(weeks.enumerated()),
                        id: \.offset
                    ) {
                        index,
                        week in
                        HStack {
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
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $scrollPosition)
            .scrollIndicators(.hidden)
        }
        .listRowInsets(
            EdgeInsets(top: 20, leading: -16, bottom: 0, trailing: -16)
        )
        .task {
            loadWeeks()
        }
        .onChange(of: mainViewModel.date) {
            loadWeeks()
        }
    }
    
    private func checkAndLoadMore(at index: Int) {
        guard !isLoadingMore else { return }
        
        if index == 0 {
            isLoadingMore = true
            loadMoreWeeks(direction: .backward)
        } else if index == weeks.count - 1 {
            isLoadingMore = true
            loadMoreWeeks(direction: .forward)
        }
    }
    
    private func loadMoreWeeks(direction: DirectionDateView) {
        guard let result = mainViewModel.loadMoreWeeks(
            currentWeeks: weeks,
            direction: direction
        ) else {
            isLoadingMore = false
            return
        }
        
        if direction == .backward {
            weeks.insert(result.newWeek, at: 0)
            scrollPosition = (scrollPosition ?? 0) + result.offset
        } else {
            weeks.append(result.newWeek)
        }
        
        isLoadingMore = false
    }
    
    @MainActor
    private func loadWeeks() {
        weeks = mainViewModel.weeksForDate(mainViewModel.date, range: -2...2)
        if let index = weeks.firstIndex(
            where: { $0.contains {
                mainViewModel.calendar
                    .isDate($0, inSameDayAs: mainViewModel.date)
            }
            }) {
            scrollPosition = index
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
