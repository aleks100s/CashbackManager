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
	let addIncomeTapped: () -> Void
	
	@Environment(\.modelContext) private var context
	
	@Query(sort: [
		SortDescriptor<Income>(\.date, order: .reverse)
	]) private var incomes: [Income]

	var body: some View {
		Group {
			if incomes.isEmpty {
				emptyView
			} else {
				contentView
			}
		}
		.navigationTitle("Выплаты кэшбэка")
		.toolbar {
			ToolbarItem(placement: .bottomBar) {
				Button("Добавить выплату") {
					addIncomeTapped()
				}
			}
		}
	}
	
	private var emptyView: some View {
		ContentUnavailableView("Выплаты не добавлены", systemImage: "rublesign.circle")
	}
	
	private var contentView: some View {
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
	}
	
	func delete(income: Income) {
		context.delete(income)
	}
}
