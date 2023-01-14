//
//  EditParametersViewModel.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 08.01.2023.
//

import Foundation

final class EditParametersViewModel: ObservableObject {
    private let service =  PersonalDataService.shared

    @Published var parameters: [EditParametersFieldProps] = []

    init() {
        bind()
    }

    func save() {
        let insertedParameters = parameters.compactMap { $0.toParameter() }
        service.saveParameters(insertedParameters)
    }

    func hideCategory(id: UUID) {
        if let index = parameters.firstIndex(where: { $0.category.id == id }) {
            parameters.remove(at: index)
        }
        service.setVisibleCategory(false, categoryId: id)
    }

    private func bind() {
        PersonalDataService.shared.$categories
            .map { $0.filter { $0.show } }
            .map { [weak self] categoies in
                categoies.map { category in
                    EditParametersFieldProps(
                        category: category,
                        value: self?.parameters.first(where: { $0.category == category })?.value
                    )
                }
            }
            .assign(to: &$parameters)
    }
}
