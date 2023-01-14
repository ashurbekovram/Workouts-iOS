//
//  EditParametersFieldProps.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 08.01.2023.
//

import Foundation

struct EditParametersFieldProps: Identifiable, Hashable {
    var id: UUID {
        category.id
    }

    let category: Category
    var value: Double?

    func toParameter() -> Parameter? {
        guard let value,
              value > 0
        else {
            return nil
        }
        return Parameter(category: category, value: value)
    }
}
