//
//  PersonalDataView.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 07.01.2023.
//

import SwiftUI

struct PersonalDataView: View {
    @StateObject private var viewModel = PersonalDataViewModel()

    var body: some View {
        List {
            Section("Основное") {
                HStack {
                    Text("Имя")
                    Spacer()
                    Text("Рамазан")
                }
                HStack {
                    Text("Возраст")
                    Spacer()
                    Text("25")
                }
            }
            Section("Параметры") {
                NavigationLink("Настроить параметры") {
                    CategoriesSettingsView()
                }
                NavigationLink("Добавить данные") {
                    EditParametersView()
                }
            }
            Section("Последние данные") {
                if !viewModel.lastParameters.isEmpty {
                    ForEach(viewModel.lastParameters) { parameter in
                        NavigationLink(value: parameter) {
                            HStack {
                                Text(parameter.category.name)
                                Spacer()
                                Text(parameter.value.description)
                            }
                        }
                    }
                } else {
                    Text("Пока данных нет")
                }
            }
        }
        .navigationDestination(for: Parameter.self) { parameter in
            CategoryDetailView(category: parameter.category)
        }
        .navigationTitle("Мои данные")
        .scrollContentBackground(.hidden)
        .background(Color.backgroundPrimary.ignoresSafeArea())
        .safeAreaInset(edge: .top) {
            Spacer().frame(height: 8)
        }
    }
}

struct PersonalDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PersonalDataView()
        }
    }
}
