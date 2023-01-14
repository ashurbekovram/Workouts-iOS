//
//  EditParametersView.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 08.01.2023.
//

import SwiftUI

struct EditParametersView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = EditParametersViewModel()

    @FocusState private var focusedCategory: Category?

    var body: some View {
        Form {
            if viewModel.parameters.isEmpty {
                Text("Нет сохранненых категорий")
            } else {
                Section {
                    ForEach($viewModel.parameters) { $parameter in
                        HStack {
                            Text("\(parameter.category.name) (\(parameter.category.metricSystem.shortTitle))")
                            Spacer()
                            TextField("0", value: $parameter.value, format: .number)
                                .keyboardType(.decimalPad)
                                .focused($focusedCategory, equals: parameter.category)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 80)
                        }
                        .swipeActions(allowsFullSwipe: true) {
                            Button("Скрыть", role: .destructive) {
                                withAnimation {
                                    viewModel.hideCategory(id: parameter.category.id)
                                }
                            }
                            .tint(.orange)
                        }
                    }
                }
                Section {
                    Button("Сохранить") {
                        viewModel.save()
                        dismiss()
                    }
                    .disabled(!viewModel.parameters.contains { $0.toParameter() != nil })
                }
            }
        }
        .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.interactively)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.newCategoryPresented = true
                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $viewModel.newCategoryPresented) {
                    NavigationStack {
                        NewCategoryView()
                    }
                }
            }
        }
        .navigationTitle("Новые данные")
        .scrollContentBackground(.hidden)
        .background(Color.backgroundPrimary.ignoresSafeArea())
        .safeAreaInset(edge: .top) {
            Spacer().frame(height: 8)
        }
        .onAppear {
            if focusedCategory == nil {
                focusedCategory = viewModel.parameters.first?.category
            }
        }
    }
}

struct EditPersonalDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditParametersView()
        }
    }
}
