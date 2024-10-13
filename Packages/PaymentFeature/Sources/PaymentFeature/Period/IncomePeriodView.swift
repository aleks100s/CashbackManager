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
				await model.onAppear()
			}
	}
	
	private var contentView: some View {
		List {
			Section {
				HStack {
					HStack {
						Image(systemName: "chevron.left")
						
						Text("предыдущий")
					}
					.onTapGesture {
						Task {
							await model.previousMonth()
						}
					}
					
					Spacer()
					
					HStack {
						Text("следующий")
						
						Image(systemName: "chevron.right")
					}
					.onTapGesture {
						Task {
							await model.nextMonth()
						}
					}
				}
				.foregroundStyle(.blue)
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
