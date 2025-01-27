//
//  DeleteCashbackIntent.swift
//  CashbackManager
//
//  Created by Alexander on 28.08.2024.
//

import AppIntents

struct DeleteCashbackIntent: AppIntent {
	static var title: LocalizedStringResource = "Удалить кэшбэк"
	static var description: IntentDescription? = "Удаляет кэшбэк с карты по категории"
		
	@Parameter(title: "Карта")
	private var cardEntity: CardEntity?
	
	@Parameter(title: "Категория")
	private var categoryEntity: CategoryEntity?
	
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
			
			guard let cashback = card.cashback.first(where: { $0.category.id == category.id }) else {
				return "Не получилось найти кэшбэк с категорией \(category.name)"
			}
			
			cardsService.delete(cashback: cashback, from: card)
			return "Кэшбэк \"\(category.name)\" удален с карты \(card.name)!"
		}.value
		return .result(dialog: "\(result)")
	}
}
