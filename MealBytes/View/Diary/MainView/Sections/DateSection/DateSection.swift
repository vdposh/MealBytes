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
        scrollContent
            .overlay(alignment: .top) {
                weekdayView
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $mainViewModel.weekPosition)
            .scrollIndicators(.hidden)
            .onChange(of: mainViewModel.weekPosition) {
                handleWeekPositionChange(mainViewModel.weekPosition)
            }
            .onChange(of: mainViewModel.date) {
                mainViewModel.updateDateSection()
            }
    }
    
    private var scrollContent: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .center, spacing: 0) {
                ForEach(
                    Array(mainViewModel.dateSectionWeeks.enumerated()),
                    id: \.offset
                ) { index, week in
                    HStack {
                        ForEach(week, id: \.self) { date in
                            Button {
                                mainViewModel.date = date
                                mainViewModel.scrollToTop()
                            } label: {
                                Text(date.formatted(.dateTime.day()))
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 28)
                                    .contentShape(Rectangle())
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
            .frame(height: 65)
        }
    }
    
    private var weekdayView: some View {
        HStack {
            let weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
            let calendar = Calendar.current
            let selectedWeekday = calendar.component(
                .weekday,
                from: mainViewModel.date
            )
            let selectedIndex = (selectedWeekday + 5) % 7
            
            ForEach(0..<7, id: \.self) { index in
                let weekday = weekdays[index]
                let isSelected = index == selectedIndex
                let isTodayDate = mainViewModel.isToday(
                    weekdayIndex: index,
                    at: mainViewModel.weekPosition ?? 0
                )
                
                Text(weekday)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(
                        isSelected ? (isTodayDate ? .white : .accent) : (
                            isTodayDate ? .accent : .secondary
                        )
                    )
                    .frame(maxWidth: .infinity)
                    .background {
                        if isSelected {
                            Circle()
                                .fill(
                                    Color.accent
                                        .opacity(isTodayDate ? 1.0 : 0.2)
                                )
                                .frame(width: 26, height: 26)
                        }
                    }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private func handleWeekPositionChange(_ newPosition: Int?) {
        guard let newPosition,
              newPosition >= 0,
              newPosition < mainViewModel.dateSectionWeeks.count else {
            return
        }
        
        scrollTimer?.invalidate()
        
        let targetPosition = newPosition
        
        scrollTimer = Timer
            .scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                Task { @MainActor in
                    guard let finalPos = mainViewModel.weekPosition,
                          finalPos == targetPosition else { return }
                    
                    let currentWeek = mainViewModel.dateSectionWeeks[finalPos]
                    let currentDate = mainViewModel.date
                    let today = Date()
                    
                    let targetDate: Date
                    if currentWeek
                        .contains(
                            where: { mainViewModel.calendar.isDate(
                                $0,
                                inSameDayAs: today
                            )
                            }) {
                        targetDate = today
                    } else {
                        guard let newDate = mainViewModel
                            .dateByPreservingWeekday(
                                from: currentDate,
                                in: currentWeek
                            ) else { return }
                        targetDate = newDate
                    }
                    
                    guard !mainViewModel.calendar
                        .isDate(currentDate, inSameDayAs: targetDate) else {
                        return
                    }
                    
                    mainViewModel.date = targetDate
                }
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
        defer {
            mainViewModel.isLoadingMore = false
        }
        
        guard let result = mainViewModel.loadMoreWeeks(
            currentWeeks: mainViewModel.dateSectionWeeks,
            direction: direction
        ) else { return }
        
        if direction == .backward {
            mainViewModel.dateSectionWeeks.insert(result.newWeek, at: 0)
            if let currentPos = mainViewModel.weekPosition {
                mainViewModel.weekPosition = currentPos + result.offset
            }
        } else {
            mainViewModel.dateSectionWeeks.append(result.newWeek)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
