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
        
        let allDates = dateSectionWeeks.flatMap { $0 }
        if let index = allDates.firstIndex(
            where: { mainViewModel.calendar.isDate(
                $0,
                inSameDayAs: mainViewModel.date
            )
            }) {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView
                .scrollToItem(
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
            return weeks.flatMap { $0 }.count
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
            
            let allDates = weeks.flatMap { $0 }
            
            guard indexPath.item < allDates.count else {
                return cell
            }
            
            let date = allDates[indexPath.item]
            let isToday = parent.mainViewModel.calendar.isDate(
                date,
                inSameDayAs: Date()
            )
            let isSelected = parent.mainViewModel.calendar.isDate(
                date, inSameDayAs: parent.mainViewModel.date
            )
            
            cell.configure(
                date: date,
                isToday: isToday,
                isSelected: isSelected
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
            let width = collectionView.bounds.width / 7
            return CGSize(width: width, height: collectionView.bounds.height)
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
            let currentPage = Int(
                (scrollView.contentOffset.x + pageWidth / 2) / pageWidth
            )
            
            let allDates = weeks.flatMap { $0 }
            let itemsPerPage = 7
            let startIndex = currentPage * itemsPerPage
            guard startIndex + itemsPerPage <= allDates.count else { return }
            
            let weekDates = Array(
                allDates[startIndex..<startIndex + itemsPerPage]
            )
            
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
            
            let totalPages = (allDates.count + itemsPerPage - 1) / itemsPerPage
            checkAndLoadMore(currentPage: currentPage, totalPages: totalPages)
        }
        
        private func checkAndLoadMore(currentPage: Int, totalPages: Int) {
            guard !isLoadingMore else { return }
            
            if currentPage <= 0 {
                isLoadingMore = true
                parent.onLoadMore(.backward)
                isLoadingMore = false
            }
            
            else if currentPage >= totalPages - 1 {
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
