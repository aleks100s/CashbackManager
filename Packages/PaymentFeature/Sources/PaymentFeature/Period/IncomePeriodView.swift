//
//  File.swift
//  PaymentFeature
//
//  Created by Alexander on 13.10.2024.
//

import Charts
import DesignSystem
import Shared
import SwiftUI

struct IncomePeriodView: View {
	@State private var model: IncomePeriodModel
	@State private var toast: Toast?
		
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
				
				ToolbarItem(placement: .topBarTrailing) {
					Button(model.isAllTimeModeOn ? "По месяцам" : "Все время") {
						hapticFeedback(.light)
						Task {
							await model.toggleAllTimeMode()
						}
					}
				}
			}
			.toast(item: $toast)
			.onFirstAppear {
				Task {
					do {
						try await model.onAppear()
					} catch {
						print(error)
					}
				}
			}
	}
	
	private var contentView: some View {
		List {
			Section {
				HStack {
					if model.isAllTimeModeOn {
						Text("Все время")
					} else {
						Text("\(Text(model.startDate, format: .dateTime.month(.wide))) \(Text(model.startDate, format: .dateTime.year()))")
					}
					
					Spacer()
					
					Text("Период")
						.foregroundStyle(.secondary)
				}

				
				HStack {
					Text(model.total, format: .currency(code: "RUB").precision(.fractionLength(.zero)))
					
					Spacer()
					
					Text("Сумма")
						.foregroundStyle(.secondary)
				}
				
				if !model.chartData.isEmpty {
					Chart(model.chartData) { data in
						SectorMark(
							angle: .value(data.label, data.value),
							innerRadius: .ratio(0.6),
							angularInset: 3
						)
						.cornerRadius(6)
						.foregroundStyle(Color(hex: data.color))
						.annotation(position: .overlay) {
							Text("\(data.label)\n\(Text(data.value, format: .currency(code: "RUB").precision(.fractionLength(.zero))))")
								.font(.caption)
								.multilineTextAlignment(.center)
								.background {
									Text("\(data.label)\n\(Text(data.value, format: .currency(code: "RUB").precision(.fractionLength(.zero))))")
										.font(.caption)
										.multilineTextAlignment(.center)
										.foregroundStyle(.background)
										.offset(x: 0, y: 0)
										.blur(radius: 2)
								}
						}
					}
					.chartLegend(.visible)
					.scaledToFill()
					.padding()
				}
			}

			if !model.isAllTimeModeOn {
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
									Task {
										toast = Toast(title: "Транзакция удалена")
										await model.delete(income: income)
									}
								}
							}
					}
					.onDelete { indexSet in
						Task {
							await model.delete(indexSet: indexSet)
						}
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
