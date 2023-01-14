//
//  HomeView.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 06.01.2023.
//

import SwiftUI

struct ListItem: Identifiable, Hashable {
    let id: Int
    let name: String
}

struct HomeView: View {
    let items = [
        ListItem(id: 1, name: "Персональные данные"),
        ListItem(id: 2, name: "Тренировки"),
        ListItem(id: 3, name: "Справочник")
    ]

    @State var navigationPath = NavigationPath()

    @State var presented: Bool = false

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List(items) { item in
                NavigationLink(item.name, value: item)
            }
            .navigationDestination(for: ListItem.self) { listItem in
                if listItem.id == 1 {
                    PersonalDataView()
                } else {
                    Text("Empty")
                }
            }
            .navigationTitle("Workouts")
            .scrollContentBackground(.hidden)
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .safeAreaInset(edge: .top) {
                Spacer().frame(height: 8)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
