//
//  DateCell.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19.05.2026.
//

import SwiftUI
import UIKit

class DateCell: UICollectionViewCell {
    static let reuseIdentifier = "DateCell"
    
    private var weekContainerView: UIStackView!
    private var weekDates: [Date] = []
    private var onDateSelected: ((Date) -> Void)?
    private var mainViewModel: MainViewModel?
    private var dayButtons: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWeekView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWeekView() {
        weekContainerView = UIStackView()
        weekContainerView.axis = .horizontal
        weekContainerView.distribution = .fillEqually
        weekContainerView.alignment = .fill
        weekContainerView.spacing = 5
        weekContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(weekContainerView)
        
        NSLayoutConstraint.activate([
            weekContainerView.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor
                .constraint(
                    equalTo: weekContainerView.trailingAnchor,
                    constant: 16
                ),
            weekContainerView.topAnchor
                .constraint(equalTo: contentView.topAnchor),
            weekContainerView.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor)
        ])
        
        for i in 0..<7 {
            let button = createDayButton(index: i)
            weekContainerView.addArrangedSubview(button)
            dayButtons.append(button)
        }
    }
    
    private func createDayButton(index: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = index
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2.5
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let weekdayLabel = UILabel()
        weekdayLabel.textAlignment = .center
        weekdayLabel.font = .systemFont(ofSize: 11, weight: .medium)
        
        let dayLabel = UILabel()
        dayLabel.textAlignment = .center
        dayLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        stackView.addArrangedSubview(weekdayLabel)
        stackView.addArrangedSubview(dayLabel)
        
        button.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        
        button.accessibilityElements = [weekdayLabel, dayLabel]
        
        let action = UIAction { [weak self] _ in
            self?.didTapDay(at: index)
        }
        button.addAction(action, for: .touchUpInside)
        
        return button
    }
    
    func configure(
        weekDates: [Date],
        mainViewModel: MainViewModel,
        onDateSelected: @escaping (Date) -> Void
    ) {
        self.weekDates = weekDates
        self.mainViewModel = mainViewModel
        self.onDateSelected = onDateSelected
        
        updateDays()
    }
    
    private func updateDays() {
        guard let mainViewModel = mainViewModel else { return }
        
        for (index, date) in weekDates.enumerated() {
            guard index < dayButtons.count else { break }
            
            let button = dayButtons[index]
            guard let labels = button.accessibilityElements as? [UILabel],
                  labels.count == 2 else { continue }
            
            let weekdayLabel = labels[0]
            let dayLabel = labels[1]
            
            weekdayLabel.text = date.formatted(.dateTime.weekday(.abbreviated))
            dayLabel.text = date.formatted(.dateTime.day())
            
            let isToday = mainViewModel.calendar.isDate(
                date,
                inSameDayAs: Date()
            )
            let isSelected = mainViewModel.calendar.isDate(
                date,
                inSameDayAs: mainViewModel.date
            )
            
            if isSelected {
                button.backgroundColor = UIColor.accent
                button.layer.cornerRadius = 18
                weekdayLabel.textColor = .white
                dayLabel.textColor = .white
            } else {
                button.backgroundColor = .clear
                if isToday {
                    weekdayLabel.textColor = UIColor.accent
                    dayLabel.textColor = UIColor.accent
                } else {
                    weekdayLabel.textColor = .secondaryLabel
                    dayLabel.textColor = .label
                }
            }
        }
    }
    
    private func didTapDay(at index: Int) {
        guard index < weekDates.count else { return }
        
        let selectedDate = weekDates[index]
        onDateSelected?(selectedDate)
        
        updateDays()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weekDates = []
        onDateSelected = nil
        mainViewModel = nil
    }
}

#Preview {
    PreviewContentView.contentView
}
