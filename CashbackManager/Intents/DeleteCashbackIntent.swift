//
//  DeleteCashbackIntent.swift
//  CashbackManager
//
//  Created by Alexander on 28.08.2024.
//

import AppIntents
import CardsService
import CategoryService
import SearchService

struct DeleteCashbackIntent: AppIntent {
	static var title: LocalizedStringResource = "Удалить кэшбэк"
	static var description: IntentDescription? = "Удаляет кэшбэк по названию карты и категории"
		
	@Parameter(title: "Название карты", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var cardName: String
	
	@Parameter(title: "Название категории", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var categoryName: String
	
	@Dependency
	private var cardsService: CardsService
	
	@Dependency
	private var categoryService: CategoryService
	
	@Dependency
	private var searchService: SearchService
	
	init() {}
	
	init(cardName: String, categoryName: String) {
		self.cardName = cardName
		self.categoryName = categoryName
	}
	
	func perform() async throws -> some ProvidesDialog {
		let result = await Task { @MainActor in
			guard let card = cardsService.getCard(name: cardName) else {
				return "Не получилось найти карту \(cardName)"
			}
			
			guard let category = categoryService.getCategory(by: categoryName) else {
				return "Не получилось найти категорию \(categoryName)"
			}
			
			guard let cashback = card.cashback.first(where: { $0.category.id == category.id }) else {
				return "Не получилось найти кэшбэк с категорией \(category.name)"
			}
			
			searchService.deindex(cashback: cashback)
			cardsService.delete(cashback: cashback, card: card)
			searchService.index(card: card)
			return "Кэшбэк \"\(category.name)\" удален с карты \(card.name)!"
		}.value
		return .result(dialog: "\(result)")
	}
}
