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
	
	public func createIncome(amount: Int, date: Date = .now, source: String? = nil) {
		let income = Income(amount: amount, date: date, source: source)
		context.insert(income)
		try? context.save()
	}
}
