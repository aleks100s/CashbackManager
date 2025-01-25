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
public final class Card: @unchecked Sendable {
	public var id: UUID
	public var name: String
	@Relationship(deleteRule: .cascade)
	public var cashback: [Cashback]
	public var color: String?
	public var isArchived: Bool = false
	public var isFavorite: Bool = false
	public var currency = String("Рубли")
	public var currencySymbol = String("₽")
	
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

	public init(id: UUID = UUID(), name: String, cashback: [Cashback] = [], color: String?, isArchived: Bool = false, isFavorite: Bool = false, currency: String = "Рубли", currencySymbol: String = "₽") {
		self.id = id
		self.name = name
		self.cashback = cashback
		self.color = color
		self.isArchived = isArchived
		self.isFavorite = isFavorite
		self.currency = currency
		self.currencySymbol = currencySymbol
	}
	
	public func has(category: Category?) -> Bool {
		guard let category else { return false }
		
		return cashback.map(\.category.id).contains(category.id)
	}
	
	public func sortedCashback(for query: String) -> [Cashback] {
		guard !query.isEmpty else { return sortedCashback }
		
		return sortedCashback.filter { $0.category.name.localizedStandardContains(query) || $0.category.synonyms?.localizedStandardContains(query) ?? false }
	}
	
	public func cashbackDescription(for query: String) -> String {
		guard !query.isEmpty else { return cashbackDescription }

		return sortedCashback(for: query)
			.map(\.description)
			.joined(separator: ", ")
	}
}
