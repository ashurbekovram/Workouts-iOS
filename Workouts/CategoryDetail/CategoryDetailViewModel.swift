//
//  CategoryDetailViewModel.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 16.01.2023.
//

import Combine
import Foundation

final class CategoryDetailViewModel: ObservableObject {
    private let service = PersonalDataService.shared

    private var bag = Set<AnyCancellable>()

    @Published var parameters: [Parameter] = []

    func observeParameters(for category: Category) {
        service.$parameters
            .sink { [weak self] parameters in
                let filteredParameters = parameters.filter { $0.category == category }
                let sortedParameters = filteredParameters.sorted { $0.date > $1.date }
                self?.parameters = sortedParameters
            }
            .store(in: &bag)
    }

    func deleteParameter(id: UUID) {
        service.removeParameter(id: id)
    }
}
