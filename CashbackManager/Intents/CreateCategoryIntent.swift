//
//  CreateCategoryIntent.swift
//  CashbackManager
//
//  Created by Alexander on 20.08.2024.
//

import AppIntents
import SwiftData

struct CreateCategoryIntent: AppIntent {
	static var title: LocalizedStringResource = "Новая категория"
	static var description: IntentDescription? = "Добавляет новую категорию кэшбэка"
		
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
			categoryService.createCategory(name: categoryName)
			return "Новая категория кэшбэка \"\(categoryName)\" добавлена!"
		}.value
		return .result(dialog: "\(result)")
	}
}

