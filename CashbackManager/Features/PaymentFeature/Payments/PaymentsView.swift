//
//  PaymentsView.swift
//  PaymentFeature
//
//  Created by Alexander on 04.11.2024.
//

import Charts
import Combine
import SwiftData
import SwiftUI
import TipKit

struct PaymentsView: View {
	let onAddIncomeTapped: () -> Void
	let onEditIncomeTapped: (Income) -> Void

	@Query(sort: [SortDescriptor<Income>(\.date, order: .forward)])
	private var allTransactions: [Income]

	@State private var isAllTimeModeOn = false
	@State private var chartData = [ChartModel]()
	@State private var firstDate = Date()
	@State private var lastDate = Date()
	
	@State private var periodTransactions: [Income] = []
	@State private var periodTotal = 0
	@State private var milesTotal = 0
	@State private var pointsTotal = 0
	@State private var periodStartDate = Date()
	@State private var periodEndDate = Date()
	
	@Environment(\.incomeService) private var incomeService
	@Environment(\.toastService) private var toastService
	
	private var isPreviousButtonDisabled: Bool {
		periodStartDate <= firstDate
	}
	
	private var isNextButtonDisabled: Bool {
		periodEndDate >= lastDate
	}

	var body: some View {
		contentView
			.navigationTitle("Выплаты кэшбэка")
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					Button("Добавить выплату") {
						onAddIncomeTapped()
					}
				}
				
				ToolbarItem(placement: .topBarTrailing) {
					Button(isAllTimeModeOn ? "По месяцам" : "Все время") {
						hapticFeedback(.light)
						isAllTimeModeOn.toggle()
					}
					.popoverTip(HowToSwitchPaymentsPeriodTip(), arrowEdge: .top)
				}
			}
			.onFirstAppear {
				setupCurrentMonthBounds()
				handleChange(transactions: allTransactions)
			}
			.onChange(of: allTransactions, initial: false) { _, transactions in
				handleChange(transactions: transactions)
			}
			.onChange(of: isAllTimeModeOn) {
				updatePeriod(transactions: allTransactions)
			}
			.onReceive(incomeService?.onChange ?? Just(()).eraseToAnyPublisher()) { _ in
				handleChange(transactions: allTransactions)
			}
	}
	
	private var contentView: some View {
		List {
			Section {
				HStack {
					if isAllTimeModeOn {
						Text("Все время")
					} else {
						Text("\(Text(periodStartDate, format: .dateTime.month(.wide))) \(Text(periodStartDate, format: .dateTime.year()))")
					}
					
					Spacer()
					
					Text("Период")
						.foregroundStyle(.secondary)
				}
				
				HStack {
					Text(periodTotal, format: .currency(code: "RUB").precision(.fractionLength(.zero)))
					
					Spacer()
					
					Text(Currency.rubles.rawValue)
						.foregroundStyle(.secondary)
				}
				
				HStack {
					Text(String(format: "%d \(Currency.miles.symbol)", milesTotal))
					
					Spacer()
					
					Text(Currency.miles.rawValue)
						.foregroundStyle(.secondary)
				}
				
				HStack {
					Text(String(format: "%d \(Currency.points.symbol)", pointsTotal))
					
					Spacer()
					
					Text(Currency.points.rawValue)
						.foregroundStyle(.secondary)
				}
				
				if !chartData.isEmpty {
					ChartView(chartData: chartData)
				}
			}

			if !isAllTimeModeOn {
				MonthChangerView(isPreviousButtonDisabled: isPreviousButtonDisabled, isNextButtonDisabled: isNextButtonDisabled) {
					changeMonth(by: -1)
				} onNextMonthTap: {
					changeMonth(by: 1)
				}

			}
			
			TransactionsPeriodView(
				transactions: periodTransactions,
				startDate: isAllTimeModeOn ? firstDate : periodStartDate,
				endDate: isAllTimeModeOn ? lastDate : periodEndDate
			) { income in
				delete(transaction: income)
			} deleteMany: { incomes in
				deleteMany(transactions: incomes)
			} edit: { income in
				onEditIncomeTapped(income)
			}
		}
		.scrollIndicators(.hidden)
	}
	
	private func handleChange(transactions: [Income]) {
		firstDate = transactions.first?.date ?? Date()
		lastDate = Date()
		updatePeriod(transactions: transactions)
	}
	
	private func updatePeriod(transactions: [Income]) {
		periodTransactions = isAllTimeModeOn ? transactions : transactions.filter { $0.date >= periodStartDate && $0.date <= periodEndDate }
		periodTotal = periodTransactions
			.filter { $0.source?.currency == Currency.rubles.rawValue }
			.map(\.amount)
			.reduce(.zero, +)
		milesTotal = periodTransactions
			.filter { $0.source?.currency == Currency.miles.rawValue }
			.map(\.amount)
			.reduce(.zero, +)
		pointsTotal = periodTransactions
			.filter { $0.source?.currency == Currency.points.rawValue }
			.map(\.amount)
			.reduce(.zero, +)
		
		var chartData = [UUID: ChartModel]()
		let otherId = UUID()
		for transaction in periodTransactions {
			let id = transaction.source?.id ?? otherId
			if chartData[id] == nil {
				let model = ChartModel(
					id: id,
					label: transaction.source?.name ?? "Прочее",
					color: transaction.source?.color ?? "#D7D7D7",
					value: transaction.amount
				)
				chartData[id] = model
			} else {
				chartData[id]?.value += transaction.amount
			}
		}
		self.chartData = Array(chartData.values).sorted(by: { $0.value > $1.value })
	}
	
	private func changeMonth(by value: Int) {
		let calendar = Calendar.current
		var components = DateComponents()
		components.month = value
		periodStartDate = calendar.date(byAdding: components, to: periodStartDate) ?? Date()
		components.month = 1
		components.minute = -1
		periodEndDate = calendar.date(byAdding: components, to: periodStartDate) ?? Date()
		updatePeriod(transactions: allTransactions)
	}
	
	private func setupCurrentMonthBounds() {
		let calendar = Calendar.current
		let currentDate = Date()
		
		// Получаем первый день текущего месяца
		let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) ?? Date()
		
		// Получаем последний день текущего месяца
		var components = DateComponents()
		components.month = 1
		components.minute = -1
		
		let endOfMonth = calendar.date(byAdding: components, to: startOfMonth) ?? Date()
		
		periodStartDate = startOfMonth
		periodEndDate = endOfMonth
	}
	
	private func delete(transaction: Income) {
		incomeService?.delete(income: transaction)
		toastService?.show(Toast(title: "Транзакция удалена"))
	}
	
	private func deleteMany(transactions: [Income]) {
		for transaction in transactions {
			incomeService?.delete(income: transaction)
		}
		
	}
}

private struct ChartView: View {
	let chartData: [ChartModel]
	
	var body: some View {
		Chart(chartData) { data in
			SectorMark(
				angle: .value(data.label, data.value),
				innerRadius: .ratio(0.6),
				angularInset: 3
			)
			.cornerRadius(6)
			.foregroundStyle(Color(hex: data.color))
			.annotation(position: .overlay) {
				Text("\(data.label)\n\(data.value)")
					.font(.caption)
					.multilineTextAlignment(.center)
					.background {
						Text("\(data.label)\n\(data.value)")
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

private struct MonthChangerView: View {
	let isPreviousButtonDisabled: Bool
	let isNextButtonDisabled: Bool
	let onPreviousMonthTap: () -> Void
	let onNextMonthTap: () -> Void
	
	var body: some View {
		Section {
			HStack {
				HStack {
					Image(systemName: "chevron.left")
					
					Text("предыдущий")
				}
				.foregroundStyle(isPreviousButtonDisabled ? .gray : .blue)
				.onTapGesture {
					hapticFeedback(.light)
					onPreviousMonthTap()
				}
				.disabled(isPreviousButtonDisabled)
				
				Spacer()
				
				HStack {
					Text("следующий")
					
					Image(systemName: "chevron.right")
				}
				.foregroundStyle(isNextButtonDisabled ? .gray : .blue)
				.onTapGesture {
					hapticFeedback(.light)
					onNextMonthTap()
				}
				.disabled(isNextButtonDisabled)
			}
		}
	}
}

private struct TransactionsPeriodView: View {
	let transactions: [Income]
	let startDate: Date
	let endDate: Date
	let delete: (Income) -> Void
	let deleteMany: ([Income]) -> Void
	let edit: (Income) -> Void
	
	var body: some View {
		Section {
			if transactions.isEmpty {
				ContentUnavailableView("Выплаты не добавлены", systemImage: "rublesign.circle")
			} else {
				ForEach(transactions) { income in
					IncomeView(income: income)
						.contentShape(.rect)
						.contextMenu {
							Button("Изменить") {
								edit(income)
							}
							Button("Удалить", role: .destructive) {
								delete(income)
							}
						}
						.onTapGesture {
							edit(income)
						}
				}
				.onDelete { indexSet in
					var selected: [Income] = []
					for index in indexSet {
						selected.append(transactions[index])
					}
					deleteMany(selected)
				}
			}
		} header: {
			Text("С \(Text(startDate, style: .date)) по \(Text(endDate, style: .date))")
		} footer: {
			Text("")
		}
	}
}
