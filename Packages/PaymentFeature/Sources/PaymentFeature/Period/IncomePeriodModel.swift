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
	}
	
	@MainActor
	func incomeTapped() {
		addIncomeTapped()
	}
	
	@MainActor
	func delete(indexSet: IndexSet) async {
		for index in indexSet {
			await delete(income: transactions[index])
		}
	}
	
	@MainActor
	func delete(income: Income) async {
		incomeService.delete(income: income)
		await fetchTransactions()
	}
	
	@MainActor
	func onAppear() async throws {
		setupCurrentMonthBounds()
		await fetchTransactions()
		let (min, max) = try await incomeService.findMinMaxDates()
		minDate = min
		maxDate = max
	}
	
	@MainActor
	func nextMonth() async {
		changeMonth(by: 1)
		await fetchTransactions()
	}
	
	@MainActor
	func previousMonth() async {
		changeMonth(by: -1)
		await fetchTransactions()
	}
	
	@MainActor
	func toggleAllTimeMode() async {
		isAllTimeModeOn.toggle()
		if isAllTimeModeOn {
			startDate = minDate
			endDate = maxDate
		} else {
			setupCurrentMonthBounds()
		}
		await fetchTransactions()
	}
	
	private func onTransactionAdded() {
		Task { [weak self] in
			await self?.fetchTransactions()
		}
	}
}

private extension IncomePeriodModel {
	@MainActor
	func fetchTransactions() async {
		let result = try? await incomeService.fetch(from: startDate, to: endDate)
		transactions = result ?? []
		total = result?.map(\.amount).reduce(.zero, +) ?? .zero
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
