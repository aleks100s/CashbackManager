//
//  File.swift
//  PaymentFeature
//
//  Created by Alexander on 13.10.2024.
//

import Combine
import Domain
import Foundation
import IncomeService
import Shared

@Observable
final class IncomePeriodModel {
	var transactions: [Income] = []
	var chartData: [ChartModel] = []
	var total: Int = .zero
	var startDate: Date = .now
	var endDate: Date = .now
	var isAllTimeModeOn = false
	
	var isNextButtonDisabled: Bool {
		endDate > .now && startDate < .now
	}
	
	var isPreviousButtonDisabled: Bool {
		startDate < minDate
	}
	
	private let incomeService: IncomeService
	private let addIncomeTapped: () -> Void
	
	private var minDate: Date = .now
	private var maxDate: Date = .now
	
	private var subscriptions = Set<AnyCancellable>()
	
	init(incomeService: IncomeService, addIncomeTapped: @escaping () -> Void) {
		self.incomeService = incomeService
		self.addIncomeTapped = addIncomeTapped
		incomeService.onChange
			.sink { [unowned self] in
				onTransactionAdded()
			}
			.store(in: &subscriptions)
		NotificationCenter.default.publisher(for: Constants.resetAppNavigationNotification)
			.sink { [unowned self] _ in
				onAppear()
			}
			.store(in: &subscriptions)
	}
	
	func incomeTapped() {
		addIncomeTapped()
	}
	
	func delete(indexSet: IndexSet) {
		for index in indexSet {
			delete(income: transactions[index])
		}
	}
	
	func delete(income: Income) {
		incomeService.delete(income: income)
		fetchTransactions()
	}
	
	func onAppear() {
		setupCurrentMonthBounds()
		fetchTransactions()
		findBorders()
	}
	
	func nextMonth() {
		changeMonth(by: 1)
		fetchTransactions()
	}
	
	func previousMonth() {
		changeMonth(by: -1)
		fetchTransactions()
	}
	
	func toggleAllTimeMode() {
		isAllTimeModeOn.toggle()
		if isAllTimeModeOn {
			startDate = minDate
			endDate = maxDate
		} else {
			setupCurrentMonthBounds()
		}
		fetchTransactions()
	}
	
	private func onTransactionAdded() {
		findBorders()
		fetchTransactions()
	}
	
	private func findBorders() {
		let (min, max) = incomeService.findMinMaxDates()
		minDate = min
		maxDate = max
	}
}

private extension IncomePeriodModel {
	func fetchTransactions() {
		let result = incomeService.fetch(from: startDate, to: endDate)
		transactions = result
		total = result.map(\.amount).reduce(.zero, +)
		var chartData = [UUID: ChartModel]()
		let otherId = UUID()
		for transaction in transactions {
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
}

private extension IncomePeriodModel {
	func changeMonth(by value: Int) {
		let calendar = Calendar.current
		var components = DateComponents()
		components.month = value
		startDate = calendar.date(byAdding: components, to: startDate) ?? Date()
		components.month = 1
		components.minute = -1
		endDate = calendar.date(byAdding: components, to: startDate) ?? Date()
	}
	
	func setupCurrentMonthBounds() {
		let calendar = Calendar.current
		let currentDate = Date()
		
		// Получаем первый день текущего месяца
		let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) ?? Date()
		
		// Получаем последний день текущего месяца
		var components = DateComponents()
		components.month = 1
		components.minute = -1
		
		let endOfMonth = calendar.date(byAdding: components, to: startOfMonth) ?? Date()
		
		startDate = startOfMonth
		endDate = endOfMonth
	}
}
