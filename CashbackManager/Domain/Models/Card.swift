//
//  Card.swift
//  CashbackManager
//
//  Created by Alexander on 14.06.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Card: @unchecked Sendable {
	var id: UUID
	var name: String
	@Relationship(deleteRule: .cascade)
	var cashback: [Cashback]
	var color: String?
	var isArchived: Bool = false
	var isFavorite: Bool = false
	var currency = String("Рубли")
	var currencySymbol = String("₽")
	
	var cashbackDescription: String {
		guard !cashback.isEmpty else { return "Нет кэшбэка" }
		
		return categoriesList
	}
	
	var isEmpty: Bool {
		cashback.isEmpty
	}
	
	private var orderedCashback: [Cashback] {
		cashback.sorted(by: { $0.order < $1.order })
	}
	
	private var categoriesList: String {
		orderedCashback.map(\.description).joined(separator: ", ")
	}

	init(id: UUID = UUID(), name: String, cashback: [Cashback] = [], color: String?, isArchived: Bool = false, isFavorite: Bool = false, currency: String = "Рубли", currencySymbol: String = "₽") {
		self.id = id
		self.name = name
		self.cashback = cashback
		self.color = color
		self.isArchived = isArchived
		self.isFavorite = isFavorite
		self.currency = currency
		self.currencySymbol = currencySymbol
	}
	
	func has(category: Category?) -> Bool {
		guard let category else { return false }
		
		return cashback.map(\.category.id).contains(category.id)
	}
	
	func filteredCashback(for query: String) -> [Cashback] {
		guard !query.isEmpty else { return orderedCashback }
		
		return orderedCashback.filter { $0.category.name.localizedStandardContains(query) || $0.category.synonyms?.localizedStandardContains(query) ?? false }
	}
	
	func cashbackDescription(for query: String) -> String {
		guard !query.isEmpty else { return cashbackDescription }

		return filteredCashback(for: query)
			.map(\.description)
			.joined(separator: ", ")
	}
}
