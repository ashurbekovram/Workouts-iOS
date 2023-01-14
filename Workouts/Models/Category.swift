//
//  Category.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 08.01.2023.
//

import Foundation

struct Category: Codable, Identifiable, Hashable {
    var id = UUID()
    let name: String
    let metricSystem: MetricSystem
    let protected: Bool
    var show: Bool = true

    static var defaultCategories: [Category] = [
        Category(name: "Вес", metricSystem: .kg, protected: true),
        Category(name: "Грудь", metricSystem: .sm, protected: false),
        Category(name: "Талия", metricSystem: .sm, protected: false),
        Category(name: "Жопа", metricSystem: .sm, protected: false),
    ]
}
