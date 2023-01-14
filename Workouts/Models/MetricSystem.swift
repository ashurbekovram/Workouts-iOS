//
//  MetricSystem.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 08.01.2023.
//

enum MetricSystem: Int, Codable, CaseIterable {
    case sm
    case kg

    var title: String {
        switch self {
        case .sm:
            return "Сантиметр"
        case .kg:
            return "Килограмм"
        }
    }

    var shortTitle: String {
        switch self {
        case .sm:
            return "см"
        case .kg:
            return "кг"
        }
    }
}
