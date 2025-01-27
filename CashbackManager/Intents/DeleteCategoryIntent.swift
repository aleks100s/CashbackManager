//
//  DeleteCategoryIntent.swift
//  CashbackManager
//
//  Created by Alexander on 28.08.2024.
//

import AppIntents

struct DeleteCategoryIntent: AppIntent {
	static var title: LocalizedStringResource = "Удалить категорию"
	static var description: IntentDescription? = "Удаляет категорию кэшбэка"
		
	@Parameter(title: "Категория")
	private var categoryEntity: CategoryEntity?
	
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
			
			categoryService.archive(category: category)
			return "Категория кэшбэка \"\(category.name)\" удалена!"
		}.value
		return .result(dialog: "\(result)")
	}
}
