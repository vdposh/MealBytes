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
        
        return collectionView
    }
    
    func updateUIView(_ collectionView: UICollectionView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.updateWeeks(dateSectionWeeks)
        collectionView.reloadData()
        
        for (weekIndex, week) in dateSectionWeeks.enumerated() {
            if week
                .contains(
                    where: { mainViewModel.calendar.isDate(
                        $0,
                        inSameDayAs: mainViewModel.date
                    )
                    }) {
                let indexPath = IndexPath(item: weekIndex, section: 0)
                collectionView.scrollToItem(
                    at: indexPath,
                    at: .centeredHorizontally,
                    animated: false
                )
                break
            }
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
        private var lastSelectedPage: Int = -1
        private var isLoadingMore = false
        
        init(parent: DateCollectionView) {
            self.parent = parent
        }
        
        func updateWeeks(_ weeks: [[Date]]) {
            self.weeks = weeks
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            numberOfItemsInSection section: Int
        ) -> Int {
            return weeks.count
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
            
            guard indexPath.item < weeks.count else {
                return cell
            }
            
            let week = weeks[indexPath.item]
            
            cell.configure(
                weekDates: week,
                mainViewModel: parent.mainViewModel
            ) { selectedDate in
                self.parent.onDateSelected(selectedDate)
            }
            
            return cell
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
            // Каждая ячейка занимает всю ширину экрана
            let width = collectionView.bounds.width
            return CGSize(width: width, height: collectionView.bounds.height)
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            let pageWidth = scrollView.bounds.width
            lastSelectedPage = Int(
                round(scrollView.contentOffset.x / pageWidth)
            )
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            scrollViewDidEndScrolling(scrollView)
        }
        
        func scrollViewDidEndDragging(
            _ scrollView: UIScrollView,
            willDecelerate decelerate: Bool
        ) {
            if !decelerate {
                scrollViewDidEndScrolling(scrollView)
            }
        }
        
        private func scrollViewDidEndScrolling(_ scrollView: UIScrollView) {
            let pageWidth = scrollView.bounds.width
            let currentPage = Int(round(scrollView.contentOffset.x / pageWidth))
            
            guard currentPage >= 0 && currentPage < weeks.count else { return }
            
            if currentPage == lastSelectedPage {
                return
            }
            
            let weekDates = weeks[currentPage]
            
            let isCurrentWeek = weekDates.contains { date in
                parent.mainViewModel.calendar.isDate(date, inSameDayAs: Date())
            }
            
            let targetDate: Date
            if isCurrentWeek {
                targetDate = Date()
            } else {
                targetDate = weekDates.first ?? weekDates[weekDates.count / 2]
            }
            
            parent.onDateSelected(targetDate)
            
            let totalPages = weeks.count
            checkAndLoadMore(currentPage: currentPage, totalPages: totalPages)
        }
        
        private func checkAndLoadMore(currentPage: Int, totalPages: Int) {
            guard !isLoadingMore else { return }
            
            if currentPage <= 0 {
                isLoadingMore = true
                parent.onLoadMore(.backward)
                isLoadingMore = false
            } else if currentPage >= totalPages - 1 {
                isLoadingMore = true
                parent.onLoadMore(.forward)
                isLoadingMore = false
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
