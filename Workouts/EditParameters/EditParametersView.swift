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
                    DatePicker("Дата", selection: $viewModel.date)
                }
                Section {
                    ForEach($viewModel.parameters) { $parameter in
                        HStack {
                            Button {
                                focusedCategory = parameter.category
                            } label: {
                                Text("\(parameter.category.name) (\(parameter.category.metricSystem.shortTitle))")
                                    .foregroundColor(Color.textPrimary)
                            }
                            Spacer()
                            TextField("0", value: $parameter.value, format: .number)
                                .keyboardType(.decimalPad)
                                .focused($focusedCategory, equals: parameter.category)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.automatic)
                                .frame(width: 120)
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
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Отмена", role: .cancel) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.save()
                    dismiss()
                } label: {
                    Text("Сохранить").fontWeight(.semibold)
                }
                .disabled(!viewModel.parameters.contains { ($0.value ?? 0) > 0 })
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.backgroundPrimary.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Новые данные")
        .scrollDismissesKeyboard(.interactively)
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
