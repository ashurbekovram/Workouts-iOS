//
//  CategoryDetailView.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 09.01.2023.
//

import SwiftUI

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
