//
//  AppRootView.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 22.09.2025.
//

import SwiftUI

enum AppScreen {
    case onboarding
}

struct AppRootView: View {
    @State var currentScreen: AppScreen = .onboarding
    
    var body: some View {
        Group {
            switch currentScreen {
            case .onboarding:
                let dataSource = OnboardingNetwork()
                let repo = FetchOnboardingRepositoryImp(dataSource: dataSource)
                let useCase = FetchOnboardingUseCaseImpl(repository: repo)
                
                OnboardingView(viewModel: OnboardingViewModel(fetchOnboardingUseCase: useCase))
            }
        }
    }
}
