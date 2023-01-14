//
//  NewCategoryView.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 08.01.2023.
//

import SwiftUI

struct NewCategoryView: View {
    @Environment(\.dismiss) var dismiss

    private let id: UUID?

    @StateObject private var service = PersonalDataService.shared
    @FocusState private var focusField: Bool
    @State private var name: String = ""
    @State private var metricSystem: Int = MetricSystem.sm.rawValue
    @State private var protected: Bool = false

    init() {
        id = nil
    }

    init(category: Category) {
        id = category.id
        _name = State(initialValue: category.name)
        _metricSystem = State(initialValue: category.metricSystem.rawValue)
        _protected = State(initialValue: category.protected)
    }

    var body: some View {
        Form {
            Section {
                TextField("Наименование категории", text: $name)
                    .focused($focusField)
                Picker("Единица измерения", selection: $metricSystem) {
                    ForEach(MetricSystem.allCases, id: \.rawValue) { item in
                        Text(item.title)
                    }
                }
                Toggle("Защитить от удаления", isOn: $protected)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.backgroundPrimary.ignoresSafeArea())
        .navigationTitle(id == nil ? "Новая категория" : "Редактирование")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    save()
                } label: {
                    Text("Сохранить").fontWeight(.semibold)
                }
                .disabled(name.count < 3)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Отмена") {
                    dismiss()
                }
            }
        }
        .onAppear {
            focusField = true
        }
    }

    private func save() {
        let metricSystem = MetricSystem(rawValue: metricSystem) ?? .sm
        let category: Category

        if let id {
            category = Category(id: id, name: name, metricSystem: metricSystem, protected: protected)
        } else {
            category = Category(name: name, metricSystem: metricSystem, protected: protected)
        }

        service.saveCategory(category)
        dismiss()
    }
}
