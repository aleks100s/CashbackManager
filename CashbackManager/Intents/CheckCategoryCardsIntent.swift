//
//  CheckCategoryCardsIntent.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import SwiftData

struct CheckCategoryCardsIntent: AppIntent {
	static var title: LocalizedStringResource = "Карта в категории"
	static var description: IntentDescription? = "Запрашивает категорию и выдает все карты с кэшбэком в этой категории"

	@Parameter(title: "Категория")
	private var categoryEntity: CategoryEntity?
	
	@Dependency
	private var cardsService: CardsService
	
	@Dependency
	private var categoryService: CategoryService
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let result = try await Task { @MainActor in
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
			
			let cards = cardsService.getCards(category: category)
			return if cards.isEmpty {
				"Не удалось найти карту с категорией \(category.name)"
			} else {
				"Для оплаты в категории \(category.name) используйте карты: \(cards.map(\.name).joined(separator: ", "))"
			}
		}.value
		return .result(dialog: "\(result)")
	}
}
