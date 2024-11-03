//
//  CardsService.swift
//  CashbackManager
//
//  Created by Alexander on 26.07.2024.
//

import Domain
import Foundation
import Shared
import SwiftData
import SwiftUI

@MainActor
public struct CardsService: @unchecked Sendable {
	private let context: ModelContext
	
	public init(context: ModelContext) {
		self.context = context
	}
	
	public func createCard(name: String) -> Card {
		let card = Card(name: name, color: Color.randomColor().toHex())
		context.insert(card)
		try? context.save()
		return card
	}
	
	public func getCard(id: UUID) -> Card? {
		fetch(by: #Predicate<Card> { $0.id == id }).first
	}
	
	public func getCard(cashbackId: UUID) -> Card? {
		fetch(by: #Predicate<Card> { $0.cashback.contains { $0.id == cashbackId } }).first
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
		fetch(by: #Predicate<Card> { !$0.cashback.isEmpty && !$0.isArchived })
	}
	
	public func getCards(category: Domain.Category) -> [Card] {
		fetch(by: #Predicate<Card> { [id = category.id] card in
			card.cashback.contains { cashback in
				cashback.category.id == id
			}
		})
	}
	
	public func archive(card: Card) {
		card.isArchived = true
		for cashback in card.cashback {
			delete(cashback: cashback, card: card)
		}
		try? context.save()
	}
	
	public func delete(cashback: Cashback, card: Card) {
		card.cashback.removeAll { $0.id == cashback.id }
		context.delete(cashback)
	}
	
	public func update(card: Card) {
		context.insert(card)
		try? context.save()
	}
	
	private func fetch(by predicate: Predicate<Card>) -> [Card] {
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor)) ?? []
	}
}
