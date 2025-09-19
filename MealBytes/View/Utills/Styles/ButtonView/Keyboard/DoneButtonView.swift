//
//  DoneButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06/07/2025.
//

import SwiftUI

struct DoneButtonView: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "checkmark")
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

#Preview {
    PreviewRdiView.rdiView
}
