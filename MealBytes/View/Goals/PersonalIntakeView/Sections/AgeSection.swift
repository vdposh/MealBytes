//
//  AgeSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24.03.2025.
//

import SwiftUI

struct AgeSection: View {
    @State private var isExpanded: Bool = false
    @ObservedObject var personalIntakeViewModel: PersonalIntakeViewModel
    
    var body: some View {
        Button {
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            LabeledContent {
                HStack(spacing: 10) {
                    Text(
                        personalIntakeViewModel.age.isEmpty
                        ? ""
                        : personalIntakeViewModel.formattedAge
                    )
                    .foregroundStyle(isExpanded ? .primary : .secondary)
                    
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(isExpanded ? .primary : .tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.default, value: isExpanded)
                }
                .padding(.trailing, 2)
            } label: {
                Text("Age")
                    .foregroundStyle(Color.primary)
            }
        }
        
        if isExpanded {
            Picker("Age", selection: $personalIntakeViewModel.age) {
                ForEach(1...120, id: \.self) { age in
                    Text("\(age)")
                        .tag("\(age)")
                }
            }
            .pickerStyle(.wheel)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewPersonalIntakeView.personalIntakeView
}
