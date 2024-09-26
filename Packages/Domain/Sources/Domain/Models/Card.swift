//
//  Card.swift
//  CashbackManager
//
//  Created by Alexander on 14.06.2024.
//

import Foundation
import SwiftData

@Model
public final class Card {
	public var id: UUID
	public var name: String
	@Relationship(deleteRule: .cascade)
	public var cashback: [Cashback]
	
	public var sortedCashback: [Cashback] {
		cashback.sorted(by: { $0.category.name < $1.category.name })
	}
	
	public var cashbackDescription: String {
		guard !cashback.isEmpty else { return "Нет кэшбэка" }
		
		return categoriesList
	}
	
	public var isEmpty: Bool {
		cashback.isEmpty
	}
	
	private var categoriesList: String {
		sortedCashback.map(\.description).joined(separator: ", ")
	}

	public init(id: UUID = UUID(), name: String, cashback: [Cashback] = []) {
		self.id = id
		self.name = name
		self.cashback = cashback
	}
	
	public func has(category: Category?) -> Bool {
		guard let category else { return false }
		
		return cashback.map(\.category).contains(category)
	}
}
