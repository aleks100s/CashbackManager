//
//  File.swift
//  PaymentFeature
//
//  Created by Alexander on 13.10.2024.
//

import Domain
import Foundation
import IncomeService

@Observable
final class IncomePeriodModel {
	var transactions: [Income] = []
	var startDate: Date = .now
	var endDate: Date = .now
	
	private let incomeService: IncomeService
	private let addIncomeTapped: () -> Void
	
	init(incomeService: IncomeService, addIncomeTapped: @escaping () -> Void) {
		self.incomeService = incomeService
		self.addIncomeTapped = addIncomeTapped
	}
	
	@MainActor
	func incomeTapped() {
		addIncomeTapped()
	}
	
	@MainActor
	func delete(indexSet: IndexSet) {
		for index in indexSet {
			delete(income: transactions[index])
		}
	}
	
	@MainActor
	func delete(income: Income) {
		incomeService.delete(income: income)
	}
	
	@MainActor
	func onAppear() async {
		await fetchCurrentMonthTransactions()
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
}

private extension IncomePeriodModel {
	@MainActor
	func fetchCurrentMonthTransactions() async {
		setupCurrentMonthBounds()
		await fetchTransactions()
	}
	
	@MainActor
	func fetchTransactions() async {
		let result = try? await incomeService.fetch(from: startDate, to: endDate)
		transactions = result ?? []
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
