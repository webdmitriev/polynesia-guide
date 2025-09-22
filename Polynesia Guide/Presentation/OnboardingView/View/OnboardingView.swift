//
//  OnboardingView.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 22.09.2025.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject var viewModel = OnboardingViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.text)
        }
        .padding()
    }
}

#Preview {
    OnboardingView()
}
