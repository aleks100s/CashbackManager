//
//  CreateCashbackIntent.swift
//  CashbackManager
//
//  Created by Alexander on 20.08.2024.
//

import AppIntents
import CardsService
import CategoryService
import Domain
import SearchService

struct CreateCashbackIntent: AppIntent {
	static var title: LocalizedStringResource = "Новый кэшбэк"
	static var description: IntentDescription? = "Добавляет новый кэшбэк в указанной категории на карту"
		
	@Parameter(title: "Название карты", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var cardName: String
	
	@Parameter(title: "Название категории", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var categoryName: String
	
	@Parameter(title: "Процент")
	var percent: Double
	
	@Dependency
	private var cardsService: CardsService
	
	@Dependency
	private var categoryService: CategoryService
	
	@Dependency
	private var searchService: SearchService
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let result = await Task { @MainActor in
			guard let card = cardsService.getCard(name: cardName) else {
				return "Карта \"\(cardName)\" не найдена"
			}
			
			guard let category = categoryService.getCategory(by: categoryName) else {
				return "Не получилось найти категорию \(categoryName)"
			}
			
			let cashback = Cashback(category: category, percent: percent / 100)
			guard !card.has(category: category) else {
				return "Нельзя добавить несколько кэшбеков с одинаковой категорией \"\(categoryName)\""
			}
			
			card.cashback.append(cashback)
			searchService.index(card: card)
			return "Новая категория кэшбэка \"\(categoryName)\" \(String(format: "%.1f", percent)) добавлена на карту \(cardName)!"
		}.value
		return .result(dialog: "\(result)")
	}
}
