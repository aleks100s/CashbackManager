//
//  CreateCashbackIntent.swift
//  CashbackManager
//
//  Created by Alexander on 20.08.2024.
//

import AppIntents
import Domain

struct CreateCashbackIntent: AppIntent {
	static var title: LocalizedStringResource = "Новый кэшбек"
		
	@Parameter(title: "Название карты", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var cardName: String
	
	@Parameter(title: "Название категории", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var categoryName: String
	
	@Parameter(title: "Процент")
	var percent: Double
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let cardsService = await AppFactory.provideCardsService()
		guard let card = cardsService.getCard(name: cardName) else {
			return .result(dialog: "Карта \"\(cardName)\" не найдена")
		}
		
		let categoryService = await AppFactory.provideCategoryService()
		guard let category = categoryService.getCategory(by: categoryName) else {
			return .result(dialog: "Не получилось найти категорию \(categoryName)")
		}
		
		let cashback = Cashback(category: category, percent: percent / 100)
		card.cashback.append(cashback)
		
		return .result(dialog: "Новая категория кэшбека \"\(categoryName)\" добавлена!")
	}
}
