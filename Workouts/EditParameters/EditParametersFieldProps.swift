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
}
