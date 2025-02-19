//
//  IncomeService.swift
//  Services
//
//  Created by Alexander on 12.10.2024.
//

import Combine
import Foundation
import SwiftData

@MainActor
struct IncomeService: @unchecked Sendable {
	var onChange: AnyPublisher<Void, Never> {
		onChangeSubject.eraseToAnyPublisher()
	}
	
	private let onChangeSubject = PassthroughSubject<Void, Never>()
	private let context: ModelContext
	
	init(context: ModelContext) {
		self.context = context
	}
	
	func createIncome(amount: Int, date: Date = .now, source: Card? = nil) {
		let income = Income(amount: amount, date: date, source: source)
		context.insert(income)
		try? context.save()
	}
	
	func updateIncome(_ income: Income) {
		context.insert(income)
		try? context.save()
		onChangeSubject.send(())
	}
	
	func delete(income: Income) {
		context.delete(income)
		try? context.save()
	}
	
	func deleteIncomes(from card: Card) {
		let id: UUID? = card.id
		let transactions = fetch(by: #Predicate<Income> { $0.source?.id == id })
		for transaction in transactions {
			context.delete(transaction)
		}
		try? context.save()
	}
	
	func fetchAll() -> [Income] {
		let descriptor = FetchDescriptor<Income>(sortBy: [.init(\.date)])
		return (try? context.fetch(descriptor)) ?? []
	}
	
	func fetchIncomes(for card: Card) -> [Income] {
		let id: UUID? = card.id
		var descriptor = FetchDescriptor<Income>(
			predicate: #Predicate<Income> { $0.source?.id == id },
			sortBy: [.init(\.date, order: .reverse)]
		)
		descriptor.fetchLimit = 10
		return (try? context.fetch(descriptor)) ?? []
	}
	
	private func fetch(by predicate: Predicate<Income>) -> [Income] {
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor)) ?? []
	}
}
