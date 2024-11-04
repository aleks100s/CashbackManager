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

struct CreateCashbackIntent: AppIntent {
	static var title: LocalizedStringResource = "Новый кэшбэк"
	static var description: IntentDescription? = "Добавляет новый кэшбэк в указанной категории на карту"
		
	@Parameter(title: "Карта")
	private var cardEntity: CardEntity?
	
	@Parameter(title: "Название категории", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var categoryName: String
	
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
			
			guard let category = categoryService.getCategory(by: categoryName) else {
				return "Не получилось найти категорию \(categoryName)"
			}
			
			let cashback = Cashback(category: category, percent: percent / 100)
			guard !card.has(category: category) else {
				return "Нельзя добавить несколько кэшбеков с одинаковой категорией \"\(categoryName)\""
			}
			
			cardsService.add(cashback: cashback, card: card)
			return "Новая категория кэшбэка \"\(categoryName)\" \(String(format: "%.1f", percent)) добавлена на карту \(card.name)!"
		}.value
		return .result(dialog: "\(result)")
	}
}
