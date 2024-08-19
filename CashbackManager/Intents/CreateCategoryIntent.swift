//
//  CreateCategoryIntent.swift
//  CashbackManager
//
//  Created by Alexander on 20.08.2024.
//

import AppIntents
import SwiftData

struct CreateCategoryIntent: AppIntent {
	static var title: LocalizedStringResource = "Новое место"
		
	@Parameter(title: "Название категории", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var categoryName: String
	
	init() {}
	
	init(categoryName: String) {
		self.categoryName = categoryName
	}
	
	func perform() async throws -> some ProvidesDialog {
		let categoryService = await AppFactory.provideCategoryService()
		categoryService.createCategory(name: categoryName)
		return .result(dialog: "Новая категория кэшбека \"\(categoryName)\" добавлена!")
	}
}

