//
//  DeleteCardIntent.swift
//  CashbackManager
//
//  Created by Alexander on 28.08.2024.
//

import AppIntents
import CardsService
import SearchService

struct DeleteCardIntent: AppIntent {
	static var title: LocalizedStringResource = "Удалить карту"
	static var description: IntentDescription? = "Удаляет карту по названию"
		
	@Parameter(title: "Название карты", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var cardName: String
	
	@Dependency
	private var cardsService: CardsService
	
	@Dependency
	private var searchService: SearchService
	
	init() {}
	
	init(cardName: String) {
		self.cardName = cardName
	}
	
	func perform() async throws -> some ProvidesDialog {
		guard let card = cardsService.getCard(name: cardName) else {
			return .result(dialog: "Не получилось найти карту \(cardName)")
		}
		
		cardsService.delete(card: card)
		searchService.deindex(card: card)
		return .result(dialog: "Карта \"\(card.name)\" удалена!")
	}
}
