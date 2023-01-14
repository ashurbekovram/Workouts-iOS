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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Добавить") {
                    viewModel.addNewParametersPresented.toggle()
                }
            }
        }
        .navigationTitle("Мои данные")
        .scrollContentBackground(.hidden)
        .background(Color.backgroundPrimary.ignoresSafeArea())
        .safeAreaInset(edge: .top) {
            Spacer().frame(height: 8)
        }
        .navigationDestination(for: Parameter.self) { parameter in
            CategoryDetailView(category: parameter.category)
        }
        .sheet(isPresented: $viewModel.addNewParametersPresented) {
            NavigationStack {
                EditParametersView()
            }
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
