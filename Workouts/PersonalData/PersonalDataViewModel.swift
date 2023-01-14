//
//  PersonalDataViewModel.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 08.01.2023.
//

import Foundation

final class PersonalDataViewModel: ObservableObject {
    @Published var lastParameters: [Parameter] = []
    @Published var addNewParametersPresented: Bool = false

    private let service = PersonalDataService.shared

    init() {
        bind()
    }

    private func bind() {
        service.$parameters
            .combineLatest(service.$categories)
            .map { (parameters, categories) in
                categories.compactMap { category in
                    return parameters.last { $0.category == category }
                }
            }
            .assign(to: &$lastParameters)
    }
}
