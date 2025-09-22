//
//  FetchOnboardingRepository.swift
//  Polynesia Guide
//
//  Created by Олег Дмитриев on 22.09.2025.
//

import Foundation
import Combine

protocol FetchOnboardingRepository {
    func getOnboardingData() -> AnyPublisher<[OnboardingStruct], Error>
}
