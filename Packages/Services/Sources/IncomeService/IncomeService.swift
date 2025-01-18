//
//  IncomeService.swift
//  Services
//
//  Created by Alexander on 12.10.2024.
//

import Combine
import Domain
import Foundation
import SwiftData

@MainActor
public struct IncomeService: @unchecked Sendable {
	public var onChange: AnyPublisher<Void, Never> {
		onChangeSubject.eraseToAnyPublisher()
	}
	
	private let onChangeSubject = PassthroughSubject<Void, Never>()
	private let context: ModelContext
	
	public init(context: ModelContext) {
		self.context = context
	}
	
	public func createIncome(amount: Int, date: Date = .now, source: Card? = nil) {
		let income = Income(amount: amount, date: date, source: source)
		context.insert(income)
		try? context.save()
	}
	
	public func updateIncome(_ income: Income) {
		context.insert(income)
		try? context.save()
		onChangeSubject.send(())
	}
	
	public func delete(income: Income) {
		context.delete(income)
		try? context.save()
	}
	
	public func deleteIncomes(from card: Card) {
		let id: UUID? = card.id
		let transactions = fetch(by: #Predicate<Income> { $0.source?.id == id })
		for transaction in transactions {
			context.delete(transaction)
		}
		try? context.save()
	}
	
	public func fetchAll() -> [Income] {
		let descriptor = FetchDescriptor<Income>(sortBy: [.init(\.date)])
		return (try? context.fetch(descriptor)) ?? []
	}
	
	private func fetch(by predicate: Predicate<Income>) -> [Income] {
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor)) ?? []
	}
}
