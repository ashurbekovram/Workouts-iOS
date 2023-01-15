//
//  CategoryDetailView.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 09.01.2023.
//

import Combine
import SwiftUI

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

struct CategoryDetailView: View {
    @StateObject private var viewModel = CategoryDetailViewModel()

    private let category: Category

    init(category: Category) {
        self.category = category
    }

    var body: some View {
        List {
            Section {
                ForEach($viewModel.parameters) { $parameter in
                    HStack {
                        Text(parameter.date.formatted(date: .abbreviated, time: .shortened))
                        Spacer()
                        Text(parameter.value.description + " " + parameter.category.metricSystem.shortTitle)
                    }
                    .swipeActions {
                        Button("Удалить", role: .destructive) {
                            viewModel.deleteParameter(id: parameter.id)
                        }
                    }
                }
            } header: {
                HStack {
                    Text("Дата")
                    Spacer()
                    Text("Значение")
                }
            }
        }
        .navigationTitle(category.name)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundPrimary.ignoresSafeArea())
        .onAppear {
            viewModel.observeParameters(for: category)
        }
    }
}
