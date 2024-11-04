//
//  CardsService.swift
//  CashbackManager
//
//  Created by Alexander on 26.07.2024.
//

import Domain
import Foundation
import SearchService
import Shared
import SwiftData
import SwiftUI
import WidgetKit

@MainActor
public struct CardsService: @unchecked Sendable {
	private let context: ModelContext
	private let searchService: SearchService
	
	public init(context: ModelContext, searchService: SearchService) {
		self.context = context
		self.searchService = searchService
	}
	
	@discardableResult
	public func createCard(name: String) -> Card {
		let card = Card(name: name, color: Color.randomColor().toHex())
		context.insert(card)
		try? context.save()
		searchService.index(card: card)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
		return card
	}
	
	public func getCard(id: UUID) -> Card? {
		fetch(by: #Predicate<Card> { $0.id == id }).first
	}
	
	public func getCard(cashbackId: UUID) -> Card? {
		fetch(by: #Predicate<Card> { $0.cashback.contains { $0.id == cashbackId } }).first
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
			delete(cashback: cashback, from: card)
		}
		try? context.save()
		searchService.deindex(card: card)
	}
	
	public func unarchive(cards: [Card]) {
		for card in cards {
			card.isArchived = false
			searchService.index(card: card)
		}
		try? context.save()
	}
	
	public func add(cashback: Cashback, to card: Card) {
		card.cashback.append(cashback)
		context.insert(cashback)
		try? context.save()
		searchService.index(card: card)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
	}
	
	public func delete(cashback: Cashback, from card: Card) {
		searchService.deindex(cashback: cashback)
		card.cashback.removeAll { $0.id == cashback.id }
		context.delete(cashback)
		try? context.save()
		searchService.index(card: card)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
	}
	
	public func update(card: Card) {
		context.insert(card)
		try? context.save()
		searchService.index(card: card)
		WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
	}
	
	private func fetch(by predicate: Predicate<Card>) -> [Card] {
		let descriptor = FetchDescriptor(predicate: predicate)
		return (try? context.fetch(descriptor)) ?? []
	}
}
