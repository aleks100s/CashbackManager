//
//  CardsService.swift
//  CashbackManager
//
//  Created by Alexander on 26.07.2024.
//

import Foundation
import SwiftData
import SwiftUI
import WidgetKit

@MainActor
struct CardsService: @unchecked Sendable {
	private let context: ModelContext
	private let searchService: SearchService
	
	init(context: ModelContext, searchService: SearchService) {
		self.context = context
		self.searchService = searchService
	}
	
	@discardableResult
	func createCard(name: String, color: String? = Color.white.toHex()) -> Card {
		let card = Card(name: name, color: color)
		context.insert(card)
		try? context.save()
		searchService.index(card: card)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
		return card
	}
	
	func getCard(id: UUID) -> Card? {
		fetch(by: #Predicate<Card> { $0.id == id }).first
	}
	
	func getCard(cashbackId: UUID) -> Card? {
		fetch(by: #Predicate<Card> { $0.cashback.contains { $0.id == cashbackId } }).first
	}
	
	func getAllCards() -> [Card] {
		fetch(by: #Predicate<Card> { !$0.cashback.isEmpty && !$0.isArchived })
	}
	
	func getCards(category: Category) -> [Card] {
		fetch(by: #Predicate<Card> { [id = category.id] card in
			card.cashback.contains { cashback in
				cashback.category.id == id
			}
		})
	}
	
	func archive(card: Card) {
		card.isArchived = true
		for cashback in card.cashback {
			delete(cashback: cashback, from: card)
		}
		try? context.save()
		searchService.deindex(card: card)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.favouriteCardsWidgetKind)
	}
	
	func unarchive(cards: [Card]) {
		for card in cards {
			card.isArchived = false
			searchService.index(card: card)
		}
		try? context.save()
	}
	
	func add(cashback: Cashback, to card: Card) {
		card.cashback.append(cashback)
		context.insert(cashback)
		try? context.save()
		searchService.index(card: card)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.favouriteCardsWidgetKind)
	}
	
	func delete(cashback: Cashback, from card: Card) {
		searchService.deindex(cashback: cashback)
		card.cashback.removeAll { $0.id == cashback.id }
		card.orderedCashback.indices.forEach { index in
			card.orderedCashback[index].order = index
		}
		context.delete(cashback)
		try? context.save()
		searchService.index(card: card)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.favouriteCardsWidgetKind)
	}
	
	func update(card: Card) {
		context.insert(card)
		try? context.save()
		searchService.index(card: card)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.favouriteCardsWidgetKind)
	}
	
	private func fetch(by predicate: Predicate<Card>) -> [Card] {
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor)) ?? []
	}
}
