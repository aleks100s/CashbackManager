//
//  CheckCardCashbackIntent.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import CardsService
import Domain
import SwiftData

struct CheckCardCashbackIntent: AppIntent {
	static var title: LocalizedStringResource = "Какой кэшбек на карте?"
	
	@Parameter(title: "Название карты")
	var cardName: String
	
	init(cardName: String) {
		self.cardName = cardName
	}
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		guard let container = try? ModelContainer(for: Card.self, Cashback.self, Domain.Category.self) else { return .result(dialog: "Не удалось проверить кэшбек") }
		
		let context = ModelContext(container)
		let cardsService = CardsService(context: context)
		let card = cardsService.getCard(by: cardName)
		return .result(dialog: "\(card?.cashbackDescription ?? "Не удалось найти карту")")
	}
}
