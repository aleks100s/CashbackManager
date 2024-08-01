//
//  CreateCardIntent.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import CardsService
import SearchService
import SwiftData

struct CreateCardIntent: AppIntent {
	static var title: LocalizedStringResource = "Новая карта"
	static var description: IntentDescription? = "Запрашивает имя для новой карты и сохраняет ее в приложении"
	
	@Parameter(title: "Название карты", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var cardName: String
	
	init(cardName: String) {
		self.cardName = cardName
	}
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let container = AppFactory.provideModelContainer()
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
