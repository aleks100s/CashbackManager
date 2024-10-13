//
//  IncomeService.swift
//  Services
//
//  Created by Alexander on 12.10.2024.
//

import Domain
import Foundation
import SwiftData

public struct IncomeService: @unchecked Sendable {
	private let context: ModelContext
	
	public init(context: ModelContext) {
		self.context = context
	}
	
	public func createIncome(amount: Int, date: Date = .now, source: Card? = nil) {
		let income = Income(amount: amount, date: date, source: source)
		context.insert(income)
		try? context.save()
	}
	
	public func delete(income: Income) {
		context.delete(income)
		try? context.save()
	}
	
	public func findMinMaxDates() async throws -> (Date, Date) {
		let result = try await fetchAll()
		return (result.first?.date ?? Date(), result.last?.date ?? Date())
	}
	
	public func fetchAll() async throws -> [Income] {
		let descriptor = FetchDescriptor<Income>(sortBy: [.init(\.date)])
		return try context.fetch(descriptor)
	}
	
	public func fetch(from: Date, to: Date) async throws -> [Income] {
		let predicate = #Predicate<Income> { income in
			income.date >= from && income.date <= to
		}
		let descriptor = FetchDescriptor(predicate: predicate, sortBy: [.init(\.date)])
		return try context.fetch(descriptor)
	}
}
