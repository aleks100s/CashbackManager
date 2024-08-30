//
//  CardsService.swift
//  CashbackManager
//
//  Created by Alexander on 26.07.2024.
//

import Domain
import Foundation
import SwiftData

public struct CardsService: @unchecked Sendable {
	private let context: ModelContext
	
	public init(context: ModelContext) {
		self.context = context
	}
	
	public func createCard(name: String) -> Card {
		let card = Card(name: name)
		context.insert(card)
		try? context.save()
		return card
	}
	
	public func getCard(id: UUID) -> Card? {
		fetch(by: #Predicate<Card> { $0.id == id }).first
	}
	
	public func getCard(name: String) -> Card? {
		let initialResult = fetch(by: #Predicate<Card> { $0.name == name })
		if initialResult.isEmpty {
			return fetch(by: #Predicate<Card> { $0.name.localizedStandardContains(name) }).first
		} else {
			return initialResult.first
		}
	}
	
	public func getAllCards() -> [Card] {
		fetch(by: #Predicate<Card> { !$0.cashback.isEmpty })
	}
	
	public func getCards(categoryName: String) -> [Card] {
		fetch(by: #Predicate<Card> { card in
			card.cashback.contains { cashback in
				cashback.category.name.localizedStandardContains(categoryName)
			}
		})
	}
	
	public func delete(card: Card) {
		context.delete(card)
	}
	
	public func delete(cashback: Cashback, card: Card) {
		card.cashback.removeAll { $0.id == cashback.id }
		context.delete(cashback)
	}
	
	private func fetch(by predicate: Predicate<Card>) -> [Card] {
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor)) ?? []
	}
}
