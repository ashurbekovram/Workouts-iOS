//
//  CategoriesSettingsView.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 08.01.2023.
//

import SwiftUI

struct CategoriesSettingsView: View {
    @StateObject private var service = PersonalDataService.shared

    @State private var categoryToEdit: Category?
    @State private var newCategoryPresented: Bool = false
    @State private var presentAlert: Bool = false

    var body: some View {
        List {
            if service.categories.isEmpty {
                Text("Пока нет категорий")
            } else {
                Section {
                    Toggle("Показывать все", sources: $service.categories, isOn: \.show)
                }
            }
            Section {
                ForEach ($service.categories, editActions: [.move]) { $category in
                    Button {
                        categoryToEdit = category
                    } label: {
                        Toggle(isOn: $category.show) {
                            HStack {
                                Text("\(category.name) (\(category.metricSystem.shortTitle))")
                                if category.protected {
                                    Image(systemName: "lock")
                                }
                                Spacer()
                            }
                        }
                    }
                    .foregroundColor(Color.textPrimary)
                    .swipeActions {
                        if !category.protected {
                            Button("Удалить", role: .destructive) {
                                service.removeCategory(id: category.id)
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    newCategoryPresented = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationTitle("Категории")
        .scrollContentBackground(.hidden)
        .background(Color.backgroundPrimary.ignoresSafeArea())
        .safeAreaInset(edge: .top) {
            Spacer().frame(height: 8)
        }
        .sheet(isPresented: $newCategoryPresented) {
            NavigationStack {
                NewCategoryView()
            }
        }
        .sheet(item: $categoryToEdit) {
            categoryToEdit = nil
        } content: { category in
            NavigationStack {
                NewCategoryView(category: category)
            }
        }
    }
}


struct CategoriesSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CategoriesSettingsView()
        }
    }
}
