//
//  FetchOnboardingUseCase.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 22.09.2025.
//

import Foundation
import Combine

protocol FetchOnboardingUseCase {
    func execute() -> AnyPublisher<[OnboardingStruct], Error>
}

final class FetchOnboardingUseCaseImpl: FetchOnboardingUseCase {
    
    private let repository: FetchOnboardingRepository
    init(repository: FetchOnboardingRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[OnboardingStruct], any Error> {
        self.repository.getOnboardingData()
    }
    
    
}
