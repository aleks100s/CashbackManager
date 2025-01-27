//
//  CreateCashbackIntent.swift
//  CashbackManager
//
//  Created by Alexander on 20.08.2024.
//

import AppIntents

struct CreateCashbackIntent: AppIntent {
	static var title: LocalizedStringResource = "Новый кэшбэк"
	static var description: IntentDescription? = "Добавляет новый кэшбэк в указанной категории на карту"
		
	@Parameter(title: "Карта")
	private var cardEntity: CardEntity?
	
	@Parameter(title: "Категория")
	private var categoryEntity: CategoryEntity?
	
	@Parameter(title: "Процент")
	var percent: Double
	
	@Dependency
	private var cardsService: CardsService
	
	@Dependency
	private var categoryService: CategoryService
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let result = try await Task { @MainActor in
			let card: Card
			if let cardEntity {
				card = cardEntity.card
			} else {
				let variants = cardsService.getAllCards().map {
					CardEntity(id: $0.id, card: $0)
				}
				let cardEntity = try await $cardEntity.requestDisambiguation(
					among: variants,
					dialog: IntentDialog(stringLiteral: "Выберите карту")
				)
				card = cardEntity.card
			}
			
			let category: Category
			if let categoryEntity {
				category = categoryEntity.category
			} else {
				let variants = categoryService.getAllCategories().map {
					CategoryEntity(id: $0.id, category: $0)
				}
				let categoryEntity = try await $categoryEntity.requestDisambiguation(
					among: variants,
					dialog: IntentDialog(stringLiteral: "Выберите категорию")
				)
				category = categoryEntity.category
			}
			
			let cashback = Cashback(category: category, percent: percent / 100)
			guard !card.has(category: category) else {
				return "Нельзя добавить несколько кэшбеков с одинаковой категорией \"\(category.name)\""
			}
			
			cardsService.add(cashback: cashback, to: card)
			return "Новая категория кэшбэка \"\(category.name)\" \(String(format: "%.1f", percent)) добавлена на карту \(card.name)!"
		}.value
		return .result(dialog: "\(result)")
	}
}
