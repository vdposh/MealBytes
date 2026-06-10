//
//  DateSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19.05.2026.
//

import SwiftUI

struct DateSection: View {
    @State private var scrollTimer: Timer?
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .center, spacing: 0) {
                ForEach(
                    Array(mainViewModel.dateSectionWeeks.enumerated()),
                    id: \.offset
                ) { index, week in
                    HStack(spacing: 5) {
                        ForEach(week, id: \.self) { date in
                            Button {
                                mainViewModel.date = date
                                mainViewModel.scrollToTop()
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
        .frame(height: 75)
        .background {
            VariableBlur(direction: .down)
                .ignoresSafeArea()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $mainViewModel.dateSectionScrollPosition)
        .scrollIndicators(.hidden)
        .onChange(of: mainViewModel.dateSectionScrollPosition) {
            oldPosition,
            newPosition in
            guard let position = newPosition,
                  position >= 0,
                  position < mainViewModel.dateSectionWeeks.count else {
                return
            }
            
            scrollTimer?.invalidate()
            
            scrollTimer = Timer
                .scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                    Task { @MainActor in
                        let week = mainViewModel.dateSectionWeeks[position]
                        let today = Date()
                        
                        let targetDate: Date
                        if week
                            .contains(
                                where: { mainViewModel.calendar.isDate(
                                    $0,
                                    inSameDayAs: today
                                )
                                }) {
                            targetDate = today
                        } else {
                            targetDate = week.first ?? week[week.count / 2]
                        }
                        
                        if !mainViewModel.calendar
                            .isDate(
                                mainViewModel.date,
                                inSameDayAs: targetDate
                            ) {
                            mainViewModel.date = targetDate
                        }
                    }
                }
        }
        .onChange(of: mainViewModel.date) {
            mainViewModel.updateDateSection()
        }
    }
    
    // MARK: - Pagination
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
        
        mainViewModel.isLoadingMore = false
    }
}

#Preview {
    PreviewContentView.contentView
}
