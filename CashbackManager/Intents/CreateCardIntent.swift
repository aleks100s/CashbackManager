//
//  CreateCardIntent.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import CardsService
import Domain
import SearchService
import SwiftData

struct CreateCardIntent: AppIntent {
	static var title: LocalizedStringResource = "Добавь новую карту"
	
	@Parameter(title: "Название карты")
	var cardName: String
	
	init(cardName: String) {
		self.cardName = cardName
	}
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		guard let container = try? ModelContainer(for: Card.self, Cashback.self, Domain.Category.self) else { return .result(dialog: "Не удалось создать карту") }
		
		let context = ModelContext(container)
		let cardsService = CardsService(context: context)
		let searchService = SearchService()
		if cardName.isEmpty {
			cardName = "Карта"
		}
		let card = cardsService.createCard(name: cardName)
		searchService.index(card: card)
		return .result(dialog: "Новая карта \"\(cardName)\" создана")
	}
}
