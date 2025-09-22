//
//  OnboardingTitle.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 22.09.2025.
//

import SwiftUI

struct OnboardingTitle: View {
    
    let title: String
    
    var body: some View {
        Text("\(title)")
            .frame(maxWidth: .infinity,alignment: .leading)
            .font(.system(size: 32, weight: .bold))
            .fontWeight(.bold)
            .lineLimit(3)
            .lineSpacing(4)
            .foregroundColor(.appText)
            .shadow(radius: 10)
    }
}
