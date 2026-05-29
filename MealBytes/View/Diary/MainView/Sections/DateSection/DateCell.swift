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
    
    private let weekdayLabel = UILabel()
    private let dayLabel = UILabel()
    private var date: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let containerView = UIStackView()
        containerView.axis = .vertical
        containerView.alignment = .center
        containerView.spacing = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        weekdayLabel.textAlignment = .center
        weekdayLabel.font = .systemFont(ofSize: 11, weight: .medium)
        
        dayLabel.textAlignment = .center
        dayLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        containerView.addArrangedSubview(weekdayLabel)
        containerView.addArrangedSubview(dayLabel)
        
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(date: Date, isToday: Bool, isSelected: Bool) {
        self.date = date
        
        weekdayLabel.text = date.formatted(.dateTime.weekday())
        dayLabel.text = date.formatted(.dateTime.day())
        
        if isSelected {
            contentView.backgroundColor = UIColor.accent
            contentView.layer.cornerRadius = 18
            weekdayLabel.textColor = .white
            dayLabel.textColor = .white
        } else {
            contentView.backgroundColor = .clear
            if isToday {
                weekdayLabel.textColor = UIColor.accent
                dayLabel.textColor = UIColor.accent
            } else {
                weekdayLabel.textColor = .secondaryLabel
                dayLabel.textColor = .label
            }
        }
    }
    
    func getDate() -> Date? {
        return date
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .clear
        date = nil
    }
}

#Preview {
    PreviewContentView.contentView
}
