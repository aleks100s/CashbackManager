//
//  ChangeCurrentCardIntent.swift
//  CashbackManager
//
//  Created by Alexander on 20.07.2024.
//

import AppIntents
import CardsService
import Domain
import Shared
import SwiftData
import WidgetKit

struct ChangeCurrentCardIntent: AppIntent {
	static var title: LocalizedStringResource = "Change Card"
	static var isDiscoverable = false
	
	@Parameter(title: "Card ID")
	var cardId: String
	
	init(cardId: String) {
		self.cardId = cardId
	}
	
	init() {}
	
	func perform() async throws -> some IntentResult {
		let service = await AppFactory.provideCardsService()
		let allCards = service.getAllCards()
		var nextCard: Card?
		if let id = UUID(uuidString: cardId) {
			if let card = service.getCard(id: id) ?? allCards.first,
			   !card.cashback.isEmpty,
			   let index = allCards.firstIndex(of: card),
			   index < allCards.endIndex - 1 {
				nextCard = allCards[index + 1]
			} else {
				nextCard = allCards.first
			}
		} else {
			nextCard = allCards.first
		}
		
		if let nextCard {
			UserDefaults.appGroup?.set(nextCard.id.uuidString, forKey: Constants.currentCardID)
			WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
		}
		return .result()
	}
}
