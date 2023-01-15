//
//  PersonalDataService.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 08.01.2023.
//

import Combine
import Foundation

fileprivate enum PersonalDataKeys {
    static let categoriesKey = "categoriesKey"
    static let parametersKey = "parametersKey"
}

final class PersonalDataService: ObservableObject {
    @Published var categories: [Category] = Category.defaultCategories
    @Published private(set) var parameters: [Parameter] = []
    @Published private(set) var lastParameters: [Parameter] = []

    private var bag = Set<AnyCancellable>()

    static let shared = PersonalDataService()

    private init() {
        if let data = UserDefaults.standard.data(forKey: PersonalDataKeys.categoriesKey),
           let decodedData = try? JSONDecoder().decode([Category].self, from: data) {
            categories = decodedData
        }

        if let data = UserDefaults.standard.data(forKey: PersonalDataKeys.parametersKey),
           let decodedData = try? JSONDecoder().decode([Parameter].self, from: data) {
            parameters = decodedData
        }
    
        bind()
    }

    func saveParameters(_ newParameters: [Parameter]) {
        parameters.append(contentsOf: newParameters)
    }

    func removeParameter(id: UUID) {
        parameters.removeAll { $0.id == id }
    }

    func saveCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
        } else {
            categories.append(category)
        }
    }

    func setVisibleCategory(_ show: Bool, categoryId: UUID) {
        guard let index = categories.firstIndex(where: { $0.id == categoryId }) else {
            return
        }
        categories[index].show = show
    }

    func removeCategory(id: UUID) {
        categories.removeAll { $0.id == id }
    }

    private func bind() {
        $categories
            .dropFirst()
            .sink { categories in
                if let data = try? JSONEncoder().encode(categories) {
                    UserDefaults.standard.set(data, forKey: PersonalDataKeys.categoriesKey)
                }
            }
            .store(in: &bag)

        $parameters
            .dropFirst()
            .sink { parameters in
                if let data = try? JSONEncoder().encode(parameters) {
                    UserDefaults.standard.set(data, forKey: PersonalDataKeys.parametersKey)
                }
            }
            .store(in: &bag)
    }
}
