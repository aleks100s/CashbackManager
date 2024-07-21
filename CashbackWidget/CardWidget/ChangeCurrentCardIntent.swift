//
//  ChangeCurrentCardIntent.swift
//  CashbackManager
//
//  Created by Alexander on 20.07.2024.
//

import AppIntents
import CashbackService
import Domain
import PersistanceManager
import WidgetKit

struct ChangeCurrentCardIntent: AppIntent {
	static var title: LocalizedStringResource = "Change Card"
	
	@Parameter(title: "Card ID")
	var cardId: String
	
	init(cardId: String) {
		self.cardId = cardId
	}
	
	init() {}
	
	func perform() async throws -> some IntentResult {
		let service = CashbackService(persistanceManager: PersistanceManager(defaults: UserDefaults(suiteName: "group.com.alextos.cashback")))
		let banks = service.getBanks()
		let cards = banks.flatMap(\.cards)
		var nextCard: Card?
		if let id = UUID(uuidString: cardId),
			let card = service.getCard(by: id),
			let index = cards.firstIndex(of: card),
			index < cards.endIndex - 1 {
			nextCard = cards[index + 1]
		} else {
			nextCard = cards.first
		}
		if let nextCard {
			service.save(currentCard: nextCard)
			WidgetCenter.shared.reloadTimelines(ofKind: CardWidget.kind)
		}
		return .result()
	}
}
