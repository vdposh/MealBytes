//
//  DoneButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06/07/2025.
//

import SwiftUI

struct DoneButtonView: View {
    var label: String = "Done"
    var action: () -> Void

    var body: some View {
        Button(label, action: action)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
