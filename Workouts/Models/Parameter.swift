//
//  Parameter.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 08.01.2023.
//

import Foundation

struct Parameter: Codable, Identifiable, Hashable {
    var id = UUID()
    var date = Date()
    let category: Category
    var value: Double
}
