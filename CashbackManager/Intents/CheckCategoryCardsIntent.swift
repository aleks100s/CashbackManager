//
//  CheckCategoryCardsIntent.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import CardsService
import CategoryService
import SwiftData

struct CheckCategoryCardsIntent: AppIntent {
	static var title: LocalizedStringResource = "Карта в категории"
	static var description: IntentDescription? = "Запрашивает название категории и выдает все карты с кэшбэком в этой категории"

	@Parameter(title: "Название категории", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var categoryName: String
	
	@Dependency
	private var cardsService: CardsService
	
	@Dependency
	private var categoryService: CategoryService
	
	init(categoryName: String) {
		self.categoryName = categoryName
	}
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		guard let category = categoryService.getCategory(by: categoryName) else {
			return .result(dialog: "Категория \"\(categoryName)\" не найдена")
		}

		let cards = cardsService.getCards(category: category)
		let result = if cards.isEmpty {
			"Не удалось найти карту с категорией \(categoryName)"
		} else {
			"Для оплаты в категории \(categoryName) используйте карты: \(cards.map(\.name).joined(separator: ", "))"
		}
		return .result(dialog: "\(result)")
	}
}
