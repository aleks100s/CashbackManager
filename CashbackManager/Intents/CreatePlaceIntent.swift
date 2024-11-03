//
//  CreatePlaceIntent.swift
//  CashbackManager
//
//  Created by Alexander on 20.08.2024.
//

import AppIntents
import CategoryService
import PlaceService
import SearchService
import SwiftData

struct CreatePlaceIntent: AppIntent {
	static var title: LocalizedStringResource = "Новое место"
	static var description: IntentDescription? = "Добавляет новое место и ассоциирует категорию кэшбэка"
		
	@Parameter(title: "Название места", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var placeName: String
	
	@Parameter(title: "Название категории", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var categoryName: String
	
	@Dependency
	private var placeService: PlaceService
	
	@Dependency
	private var categoryService: CategoryService
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let result = await Task { @MainActor in
			guard let category = categoryService.getCategory(by: categoryName) else {
				return "Не получилось найти категорию \(categoryName) и добавить место"
			}
			
			placeService.createPlace(name: placeName, category: category)
			return "Новое место \(placeName) добавлено!"
		}.value
		return .result(dialog: "\(result)")
	}
}
