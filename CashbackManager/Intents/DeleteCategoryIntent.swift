//
//  DeleteCategoryIntent.swift
//  CashbackManager
//
//  Created by Alexander on 28.08.2024.
//

import AppIntents
import CategoryService

struct DeleteCategoryIntent: AppIntent {
	static var title: LocalizedStringResource = "Удалить категорию"
	static var description: IntentDescription? = "Удаляет категорию кэшбэка"
		
	@Parameter(title: "Название категории", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var categoryName: String
	
	@Dependency
	private var categoryService: CategoryService
	
	init() {}
	
	init(categoryName: String) {
		self.categoryName = categoryName
	}
	
	func perform() async throws -> some ProvidesDialog {
		let result = await Task { @MainActor in
			guard let category = categoryService.getCategory(by: categoryName) else {
				return "Не получилось найти категорию \(categoryName)"
			}
			
			categoryService.archive(category: category)
			return "Категория кэшбэка \"\(category.name)\" удалена!"
		}.value
		return .result(dialog: "\(result)")
	}
}
