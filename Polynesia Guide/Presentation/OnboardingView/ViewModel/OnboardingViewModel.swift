//
//  OnboardingViewModel.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 22.09.2025.
//

import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {
    
    @Published var onboardingGallery: [OnboardingStruct] = []
    @Published var currentImages: [OnboardingStruct] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let fetchOnboardingUseCase: FetchOnboardingUseCase
    
    let onboardingTexts = [
        "Discover the Polynesia made for you",
        "Your personal guide, always in your pocket",
        "Where technology meets tropical paradise"
    ]
    
    init(fetchOnboardingUseCase: FetchOnboardingUseCase) {
        self.fetchOnboardingUseCase = fetchOnboardingUseCase
    }
    
    func loadOnboardingData() {
        isLoading = true
        errorMessage = nil
        
        fetchOnboardingUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] onboarding in
                self?.onboardingGallery = onboarding
                self?.selectRandomImages()
                print("Загружено изображений: \(onboarding.count)")
            }
            .store(in: &cancellables)
    }
    
    func selectRandomImages() {
        guard onboardingGallery.count >= 2 else {
            currentImages = onboardingGallery
            return
        }
        currentImages = Array(onboardingGallery.shuffled().prefix(2))
    }
    
    var randomText: String {
        onboardingTexts.randomElement() ?? "Добро пожаловать!"
    }
}
