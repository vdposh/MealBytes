//
//  AlertContentProfile.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07/08/2025.
//

import SwiftUI

struct AlertContentProfile: Identifiable {
    let type: AlertTypeProfileView
    let overrideMessage: String?
    let isSuccess: Bool
    
    var id: UUID { UUID() }
    
    var title: String {
        isSuccess ? "Done" : type.title
    }
    
    var message: String {
        overrideMessage ?? type.defaultMessage
    }
    
    var destructiveTitle: String {
        type.destructiveTitle
    }
    
    init(
        type: AlertTypeProfileView,
        overrideMessage: String? = nil,
        isSuccess: Bool = false
    ) {
        self.type = type
        self.overrideMessage = overrideMessage
        self.isSuccess = isSuccess
    }
}
