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
        
        var targetIndexPath: IndexPath?
        for (weekIndex, week) in dateSectionWeeks.enumerated() {
            if let dayIndex = week.firstIndex(
                where: { mainViewModel.calendar.isDate(
                    $0,
                    inSameDayAs: mainViewModel.date
                )
                }) {
                targetIndexPath = IndexPath(
                    item: weekIndex * 7 + dayIndex,
                    section: 0
                )
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
        private var lastWeeksCount = 0
        private var isLoadingMore = false
        weak var collectionView: UICollectionView?
        
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
            self.collectionView = collectionView
            return weeks.count * 7
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
            let isToday = parent.mainViewModel.calendar.isDate(
                date,
                inSameDayAs: Date()
            )
            let isSelected = parent.mainViewModel.calendar.isDate(
                date,
                inSameDayAs: parent.mainViewModel.date
            )
            
            cell.configure(
                date: date,
                isToday: isToday,
                isSelected: isSelected
            )
            
            return cell
        }
        
        // MARK: - UICollectionViewDelegate
        func collectionView(
            _ collectionView: UICollectionView,
            didSelectItemAt indexPath: IndexPath
        ) {
            guard let cell = collectionView.cellForItem(
                at: indexPath
            ) as? DateCell,
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
            let height: CGFloat = 65
            return CGSize(width: width, height: height)
        }
        
        // MARK: - UIScrollViewDelegate
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            scrollView.isUserInteractionEnabled = false
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            guard let collectionView = collectionView else { return }
            
            let centerPoint = CGPoint(
                x: scrollView.contentOffset.x + scrollView.bounds.width / 2,
                y: scrollView.bounds.height / 2
            )
            
            guard let centerIndexPath = collectionView
                .indexPathForItem(at: centerPoint) else {
                scrollView.isUserInteractionEnabled = true
                return
            }
            
            let weekIndex = centerIndexPath.item / 7
            
            guard weekIndex >= 0 && weekIndex < weeks.count else {
                scrollView.isUserInteractionEnabled = true
                return
            }
            
            let currentWeekStart = parent.mainViewModel.calendar.date(
                from: parent.mainViewModel.calendar
                    .dateComponents(
                        [.yearForWeekOfYear, .weekOfYear],
                        from: parent.mainViewModel.date
                    )
            ) ?? Date()
            
            let targetWeekStart = parent.mainViewModel.calendar.date(
                from: parent.mainViewModel.calendar
                    .dateComponents(
                        [.yearForWeekOfYear, .weekOfYear],
                        from: weeks[weekIndex].first ?? Date()
                    )
            ) ?? Date()
            
            let isSameWeek = parent.mainViewModel.calendar.isDate(
                currentWeekStart,
                equalTo: targetWeekStart,
                toGranularity: .weekOfYear
            )
            
            guard !isSameWeek else {
                scrollView.isUserInteractionEnabled = true
                return
            }
            
            let weekDates = weeks[weekIndex]
            
            let isCurrentWeek = weekDates.contains { date in
                parent.mainViewModel.calendar.isDate(date, inSameDayAs: Date())
            }
            
            let targetDate: Date
            if isCurrentWeek {
                targetDate = Date()
            } else {
                targetDate = weekDates.first ?? weekDates[weekDates.count / 2]
            }
            
            if !parent.mainViewModel.calendar
                .isDate(parent.mainViewModel.date, inSameDayAs: targetDate) {
                parent.onDateSelected(targetDate)
            }
            
            checkAndLoadMore(currentPage: weekIndex, totalPages: weeks.count)
            
            scrollView.isUserInteractionEnabled = true
        }
        
        // MARK: - Helper
        private func checkAndLoadMore(currentPage: Int, totalPages: Int) {
            guard !isLoadingMore else { return }
            
            if currentPage <= 1 {
                isLoadingMore = true
                lastWeeksCount = weeks.count
                parent.onLoadMore(.backward)
                isLoadingMore = false
            } else if currentPage >= totalPages - 2 {
                isLoadingMore = true
                lastWeeksCount = weeks.count
                parent.onLoadMore(.forward)
                isLoadingMore = false
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
