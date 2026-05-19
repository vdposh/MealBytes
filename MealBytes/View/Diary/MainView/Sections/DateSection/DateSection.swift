//
//  DateSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19.05.2026.
//

import SwiftUI

struct DateSection: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            EmptyView()
        } header: {
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
                    .buttonStyle(.plain)
                }
            }
        }
        .transaction { $0.animation = nil }
        .listRowInsets(
            EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
