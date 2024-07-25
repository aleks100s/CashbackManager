//
//  ChangeCurrentCardIntent.swift
//  CashbackManager
//
//  Created by Alexander on 20.07.2024.
//

import AppIntents
import CashbackService
import Domain
import SwiftData
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
		guard let container = try? ModelContainer(for: Card.self, Cashback.self, Domain.Category.self) else { return .result() }
		
		let context = ModelContext(container)
		
		let allCardsPredicate = #Predicate<Card> { !$0.cashback.isEmpty }
		let allCardsDescriptor = FetchDescriptor(predicate: allCardsPredicate)
		let allCards = (try? context.fetch(allCardsDescriptor)) ?? []
		
		var nextCard: Card?
		if let id = UUID(uuidString: cardId) {
			let currentCardPredicate = #Predicate<Card> { $0.id == id && !$0.cashback.isEmpty }
			let currentCardDescriptor = FetchDescriptor(predicate: currentCardPredicate)
			if let card = (try? context.fetch(currentCardDescriptor).first) ?? allCards.first,
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
			UserDefaults.appGroup?.set(nextCard.id.uuidString, forKey: "CurrentCardID")
			WidgetCenter.shared.reloadTimelines(ofKind: CardWidget.kind)
		}
		return .result()
	}
}

private extension UserDefaults {
	static let appGroup = UserDefaults(suiteName: "group.com.alextos.cashback")
}
