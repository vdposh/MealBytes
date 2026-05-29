//
//  DateCollectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19.05.2026.
//

import SwiftUI
import UIKit

struct DateCollectionView: UIViewRepresentable {
    let mainViewModel: MainViewModel
    let dateSectionWeeks: [[Date]]
    let onDateSelected: (Date) -> Void
    let onLoadMore: (DirectionDateView) -> Void
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = .fast
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        collectionView.register(
            DateCell.self,
            forCellWithReuseIdentifier: DateCell.reuseIdentifier
        )
        collectionView.allowsSelection = true
        
        return collectionView
    }
    
    func updateUIView(_ collectionView: UICollectionView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.updateWeeks(dateSectionWeeks)
        collectionView.reloadData()
        
        // Находим индекс даты для скролла
        var targetIndexPath: IndexPath?
        for (weekIndex, week) in dateSectionWeeks.enumerated() {
            if let dayIndex = week.firstIndex(where: { mainViewModel.calendar.isDate($0, inSameDayAs: mainViewModel.date) }) {
                targetIndexPath = IndexPath(item: weekIndex * 7 + dayIndex, section: 0)
                break
            }
        }
        
        if let indexPath = targetIndexPath {
            collectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: false
            )
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject,
                       UICollectionViewDataSource,
                       UICollectionViewDelegateFlowLayout {
        var parent: DateCollectionView
        private var weeks: [[Date]] = []
        private var isLoadingMore = false
        private var isUpdatingDate = false
        private var lastWeeksCount = 0
        
        init(parent: DateCollectionView) {
            self.parent = parent
        }
        
        func updateWeeks(_ weeks: [[Date]]) {
            self.weeks = weeks
        }
        
        // MARK: - UICollectionViewDataSource
        func collectionView(
            _ collectionView: UICollectionView,
            numberOfItemsInSection section: Int
        ) -> Int {
            return weeks.count * 7 // 7 дней в неделе
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DateCell.reuseIdentifier,
                for: indexPath
            ) as? DateCell else {
                return UICollectionViewCell()
            }
            
            let weekIndex = indexPath.item / 7
            let dayIndex = indexPath.item % 7
            
            guard weekIndex < weeks.count,
                  dayIndex < weeks[weekIndex].count else {
                return cell
            }
            
            let date = weeks[weekIndex][dayIndex]
            let isToday = parent.mainViewModel.calendar.isDate(date, inSameDayAs: Date())
            let isSelected = parent.mainViewModel.calendar.isDate(date, inSameDayAs: parent.mainViewModel.date)
            
            cell.configure(date: date, isToday: isToday, isSelected: isSelected)
            
            return cell
        }
        
        // MARK: - UICollectionViewDelegate
        func collectionView(
            _ collectionView: UICollectionView,
            didSelectItemAt indexPath: IndexPath
        ) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? DateCell,
                  let date = cell.getDate() else { return }
            parent.onDateSelected(date)
        }
        
        // MARK: - UICollectionViewDelegateFlowLayout
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
            let width = collectionView.bounds.width / 7
            return CGSize(width: width, height: collectionView.bounds.height)
        }
        
        // MARK: - UIScrollViewDelegate
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            if isUpdatingDate {
                scrollView.isScrollEnabled = false
                DispatchQueue.main.async {
                    scrollView.isScrollEnabled = true
                }
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            guard !isUpdatingDate else { return }
            
            let pageWidth = scrollView.bounds.width
            let currentPage = Int(round(scrollView.contentOffset.x / pageWidth))
            
            let currentWeekIndex = currentPage
            
            guard currentWeekIndex >= 0 && currentWeekIndex < weeks.count else { return }
            
            let weekDates = weeks[currentWeekIndex]
            
            let isCurrentWeek = weekDates.contains { date in
                parent.mainViewModel.calendar.isDate(date, inSameDayAs: Date())
            }
            
            let targetDate: Date
            if isCurrentWeek {
                targetDate = Date()
            } else {
                targetDate = weekDates.first ?? weekDates[weekDates.count / 2]
            }
            
            isUpdatingDate = true
            scrollView.isScrollEnabled = false
            
            parent.onDateSelected(targetDate)
            
            Task { @MainActor in
                self.isUpdatingDate = false
                scrollView.isScrollEnabled = true
            }
            
            let totalPages = weeks.count
            checkAndLoadMore(currentPage: currentWeekIndex, totalPages: totalPages)
        }
        
        func scrollViewDidEndDragging(
            _ scrollView: UIScrollView,
            willDecelerate decelerate: Bool
        ) {
            if !decelerate {
                scrollViewDidEndDecelerating(scrollView)
            }
        }
        
        // MARK: - Helper
        private func checkAndLoadMore(currentPage: Int, totalPages: Int) {
            guard !isLoadingMore else { return }
            
            if currentPage <= 0, weeks.count != lastWeeksCount {
                isLoadingMore = true
                lastWeeksCount = weeks.count
                parent.onLoadMore(.backward)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.isLoadingMore = false
                }
            } else if currentPage >= totalPages - 1,
                      weeks.count != lastWeeksCount {
                isLoadingMore = true
                lastWeeksCount = weeks.count
                parent.onLoadMore(.forward)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.isLoadingMore = false
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
