//
//  CaloriesSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct CaloriesSection: View {
    let summaries: [NutrientType: Double]
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            VStack(spacing: 10) {
                HStack {
                    Text("Calories")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 5) {
                        Text(
                            mainViewModel.formatter.formattedValue(
                                summaries[.calories],
                                unit: .empty,
                                alwaysRoundUp: true
                            )
                        )
                        
                        if mainViewModel.canDisplayIntake() {
                            Text("/")
                                .foregroundStyle(.secondary)
                            Text(mainViewModel.intake)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .layoutPriority(1)
                    .font(.callout)
                    .fontWeight(.medium)
                }
                
                if mainViewModel.hasMealItems {
                    if mainViewModel.canDisplayIntake() {
                        ProgressView(value: mainViewModel.intakeProgress)
                            .progressViewStyle(.linear)
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                            .frame(height: 6)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .tint(.accent)
                    }
                    
                    HStack {
                        let nutrients = mainViewModel.formattedNutrients(
                            source: .summaries(summaries)
                        )
                        ForEach(["Fat", "Carbs", "Protein"], id: \.self) { key in
                            NutrientLabel(
                                label: String(key.prefix(1)),
                                formattedValue: nutrients[key] ?? ""
                            )
                        }
                        
                        if mainViewModel.canDisplayIntake() {
                            Text(
                                mainViewModel.intakePercentage(
                                    for: summaries[.calories]
                                )
                            )
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
            }
            .transaction { $0.animation = nil }
            .lineLimit(1)
        } header: {
            dateSection
        }
        .id(mainViewModel.displayIntake)
    }
    
    private var dateSection: some View {
        HStack {
            ForEach(-3...3, id: \.self) { offset in
                let date = mainViewModel.dateByAddingOffset(for: offset)
                
                Button {
                    withAnimation {
                        mainViewModel.date = date
                    }
                } label: {
                    DateView(
                        date: date,
                        isToday: Calendar.current.isDate(
                            date,
                            inSameDayAs: Date()
                        ),
                        isSelected: Calendar.current.isDate(
                            date,
                            inSameDayAs: mainViewModel.date
                        ),
                        mainViewModel: mainViewModel
                    )
                }
                .buttonStyle(ButtonStyleInvisible())
            }
        }
        .listRowInsets(
            EdgeInsets(top: 20, leading: 0, bottom: 16, trailing: 0)
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
