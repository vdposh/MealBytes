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
                    HStack {
                        ForEach(week, id: \.self) { date in
                            Button {
                                mainViewModel.date = date
                                mainViewModel.scrollToTop()
                            } label: {
                                dateView(for: date)
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
        .frame(height: 65)
        .overlay(alignment: .top) {
            weekdayView
        }
        .background {
            VariableBlur(direction: .down)
                .ignoresSafeArea()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $mainViewModel.weekPosition)
        .scrollIndicators(.hidden)
        .onChange(of: mainViewModel.weekPosition) { _, newPosition in
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
                        
                        let currentWeek = mainViewModel
                            .dateSectionWeeks[finalPos]
                        let currentDate = mainViewModel.date
                        
                        guard let newDate = mainViewModel
                            .dateByPreservingWeekday(
                                from: currentDate,
                                in: currentWeek
                            ) else { return }
                        
                        guard mainViewModel.shouldUpdateDate(
                            to: newDate,
                            from: currentDate
                        ) else { return }
                        
                        mainViewModel.date = newDate
                    }
                }
        }
        .onChange(of: mainViewModel.date) {
            mainViewModel.updateDateSection()
        }
    }
    
    private func dateView(for date: Date) -> some View {
        Text(date.formatted(.dateTime.day()))
            .fontWeight(.medium)
            .frame(maxWidth: .infinity)
            .padding(.top, 28)
            .contentShape(Rectangle())
            .transaction { $0.animation = nil }
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
                let isTodayDate = isToday(index)
                
                Text(weekday)
                    .font(.caption2)
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
    
    private func isToday(_ weekdayIndex: Int) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        
        guard let position = mainViewModel.weekPosition,
              position >= 0,
              position < mainViewModel.dateSectionWeeks.count else {
            return false
        }
        
        let currentWeek = mainViewModel.dateSectionWeeks[position]
        let date = currentWeek[weekdayIndex]
        return calendar.isDate(date, inSameDayAs: today)
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
