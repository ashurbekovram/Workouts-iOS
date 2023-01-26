//
//  CategoryDetailView.swift
//  Workouts
//
//  Created by Ramazan Ashurbekov on 09.01.2023.
//

import Charts
import SwiftUI

struct CategoryDetailView: View {
    @StateObject private var viewModel = CategoryDetailViewModel()

    @State var showChart: Bool = true

    private let category: Category

    init(category: Category) {
        self.category = category
    }

    var body: some View {
        List {
            Section {
                CategoryChartView(parameters: viewModel.parameters)
            }
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


struct CategoryChartView: View {
    var parameters: [Parameter]

    var body: some View {
        if parameters.count == 1 {
            Chart {
                RuleMark(
                    xStart: .value("Start", Calendar.current.date(byAdding: .day, value: 3, to: parameters[0].date) ?? Date.distantPast),
                    xEnd: .value("End", Calendar.current.date(byAdding: .day, value: -3, to: parameters[0].date) ?? Date.distantFuture),
                    y: .value("Value", parameters[0].value)
                )
                .foregroundStyle(.red)
                .symbol(.circle)

                PointMark(
                    x: .value("День", parameters[0].date),
                    y: .value("Значение", parameters[0].value)
                )
                .symbol(.circle)
                .lineStyle(.init(lineWidth: 1))
            }
        } else {
            Chart(parameters) { parameter in
                let x = parameter.date
                let y = parameter.value

                LineMark(
                    x: .value("День", x),
                    y: .value("Значение", y)
                )
                .symbol(.circle)
                .symbolSize(60)
                .foregroundStyle(.orange)

                AreaMark(
                    x: .value("День", x),
                    y: .value("Значение", y)
                )
                .symbol(.circle)
                .symbolSize(60)
                .foregroundStyle(Gradient(colors: [.orange.opacity(0.4), .orange.opacity(0.1)]))
            }
            .chartXAxisLabel("День")
            .chartYAxisLabel("Значение")
        }
    }
}

