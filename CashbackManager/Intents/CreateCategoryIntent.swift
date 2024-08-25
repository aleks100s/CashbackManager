//
//  CreateCategoryIntent.swift
//  CashbackManager
//
//  Created by Alexander on 20.08.2024.
//

import AppIntents
import CategoryService
import SwiftData

struct CreateCategoryIntent: AppIntent {
	static var title: LocalizedStringResource = "Новая категория"
	static var description: IntentDescription? = "Добавляет новую категорию кэшбека"
		
	@Parameter(title: "Название категории", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var categoryName: String
	
	@Dependency
	private var categoryService: CategoryService
	
	init() {}
	
	init(categoryName: String) {
		self.categoryName = categoryName
	}
	
	func perform() async throws -> some ProvidesDialog {
		categoryService.createCategory(name: categoryName)
		return .result(dialog: "Новая категория кэшбека \"\(categoryName)\" добавлена!")
	}
}

