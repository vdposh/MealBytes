//
//  DatePickerView.swift
//  MealBytes
//
//  Created by Porshe on 19/03/2025.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    let mainViewModel: MainViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button("Today") {
                    mainViewModel.selectDate(
                        Date(),
                        selectedDate: &selectedDate,
                        isPresented: &isPresented
                    )
                }
                
                Button {
                    mainViewModel.changeMonth(
                        by: -1,
                        selectedDate: &selectedDate
                    )
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)
                }
                
                Button {
                    mainViewModel.changeMonth(
                        by: 1,
                        selectedDate: &selectedDate
                    )
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .font(.headline)
            .padding(.bottom)
            .padding(.horizontal)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 7)
            ) {
                ForEach(
                    mainViewModel.daysForCurrentMonth(
                        selectedDate: selectedDate
                    ),
                    id: \.self
                ) { date in
                    Button {
                        mainViewModel.selectDate(
                            date,
                            selectedDate: &selectedDate,
                            isPresented: &isPresented
                        )
                    } label: {
                        Text("\(mainViewModel.dayComponent(for: date))")
                            .foregroundColor(mainViewModel.color(
                                for: .day,
                                date: date,
                                isSelected: mainViewModel.calendar.isDate(
                                    selectedDate,
                                    inSameDayAs: date
                                ),
                                isToday: mainViewModel.calendar
                                    .isDateInToday(date)
                            ))
                            .frame(width: 40, height: 40)
                            .background(mainViewModel.color(
                                for: .day,
                                date: date,
                                isSelected: mainViewModel.calendar.isDate(
                                    selectedDate,
                                    inSameDayAs: date
                                ),
                                forBackground: true
                            ))
                            .cornerRadius(12)
                            .font(.callout)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        MainView(mainViewModel: MainViewModel())
    }
}
