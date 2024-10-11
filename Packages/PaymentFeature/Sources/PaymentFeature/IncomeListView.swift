//
//  File.swift
//  IncomeFeature
//
//  Created by Alexander on 11.10.2024.
//

import Domain
import SwiftData
import SwiftUI

struct IncomeListView: View {
	@Query private var incomes: [Income]
	
	@Environment(\.modelContext) private var context

	var body: some View {
		List {
			ForEach(incomes) { income in
				IncomeView(income: income)
					.contentShape(.rect)
					.contextMenu {
						Button("Удалить", role: .destructive) {
							delete(income: income)
						}
					}
			}
			.onDelete { indexSet in
				for index in indexSet {
					delete(income: incomes[index])
				}
			}
		}
		.navigationTitle("Выплаты кэшбэка")
		.toolbar {
			ToolbarItem(placement: .bottomBar) {
				Button("Добавить выплату") {
					context.insert(Income(amount: 457, date: .now, source: "ВТБ"))
				}
			}
		}
	}
	
	func delete(income: Income) {
		context.delete(income)
	}
}
