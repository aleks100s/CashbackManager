//
//  File.swift
//  PaymentFeature
//
//  Created by Alexander on 13.10.2024.
//

import SwiftUI

struct IncomePeriodView: View {
	@State private var model: IncomePeriodModel
		
	init(model: IncomePeriodModel) {
		self.model = model
	}
	
	var body: some View {
		contentView
			.navigationTitle("Выплаты кэшбэка")
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					Button("Добавить выплату") {
						model.incomeTapped()
					}
				}
			}
			.task {
				do {
					try await model.onAppear()
				} catch {
					print(error)
				}
			}
	}
	
	private var contentView: some View {
		List {
			Section("Сводка") {
				HStack {
					Text("\(Text(model.startDate, format: .dateTime.month(.wide))) \(Text(model.startDate, format: .dateTime.year()))")
					
					Spacer()
					
					Text("Месяц")
						.foregroundStyle(.secondary)
				}
				
				HStack {
					Text(model.total, format: .currency(code: "RUB").precision(.fractionLength(.zero)))
					
					Spacer()
					
					Text("Сумма")
						.foregroundStyle(.secondary)
				}
			}

			Section {
				HStack {
					HStack {
						Image(systemName: "chevron.left")
						
						Text("предыдущий")
					}
					.foregroundStyle(model.isPreviousButtonDisabled ? .gray : .blue)
					.onTapGesture {
						Task {
							await model.previousMonth()
						}
					}
					.disabled(model.isPreviousButtonDisabled)
					
					Spacer()
					
					HStack {
						Text("следующий")
						
						Image(systemName: "chevron.right")
					}
					.foregroundStyle(model.isNextButtonDisabled ? .gray : .blue)
					.onTapGesture {
						Task {
							await model.nextMonth()
						}
					}
					.disabled(model.isNextButtonDisabled)
				}
			}
			
			Section {
				if model.transactions.isEmpty {
					ContentUnavailableView("Выплаты не добавлены", systemImage: "rublesign.circle")
				} else {
					ForEach(model.transactions) { income in
						IncomeView(income: income)
							.contentShape(.rect)
							.contextMenu {
								Button("Удалить", role: .destructive) {
									model.delete(income: income)
								}
							}
					}
					.onDelete { indexSet in
						model.delete(indexSet: indexSet)
					}
				}
			} header: {
				Text("С \(Text(model.startDate, style: .date)) по \(Text(model.endDate, style: .date))")
			} footer: {
				Text("")
			}
		}
	}
}
