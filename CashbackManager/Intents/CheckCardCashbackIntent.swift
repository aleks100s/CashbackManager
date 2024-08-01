//
//  CheckCardCashbackIntent.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import CardsService
import SwiftData

struct CheckCardCashbackIntent: AppIntent {
	static var title: LocalizedStringResource = "Кэшбек на карте"
	static var description: IntentDescription? = "Запрашивает имя карты и выдает кэшбеки по ней"
	
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
		let card = cardsService.getCard(name: cardName)
		return .result(dialog: "\(card?.cashbackDescription ?? "Не удалось найти карту \(cardName)")")
	}
}
