//
//  CheckCategoryCardsIntent.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import CardsService
import SwiftData

struct CheckCategoryCardsIntent: AppIntent {
	static var title: LocalizedStringResource = "Карта в категории"
	
	@Parameter(title: "Название категории", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var categoryName: String
	
	init(categoryName: String) {
		self.categoryName = categoryName
	}
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let container = AppFactory.provideModelContainer()
		let context = ModelContext(container)
		let cardsService = CardsService(context: context)
		let cards = cardsService.getCards(categoryName: categoryName)
		return .result(dialog: "\(cards.isEmpty ? "Не удалось найти карту с категорией \(categoryName)" : cards.map(\.name).joined(separator: ", "))")
	}
}
