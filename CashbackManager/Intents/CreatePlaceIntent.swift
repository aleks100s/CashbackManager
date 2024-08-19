//
//  CreatePlaceIntent.swift
//  CashbackManager
//
//  Created by Alexander on 20.08.2024.
//

import AppIntents
import SwiftData

struct CreatePlaceIntent: AppIntent {
	static var title: LocalizedStringResource = "Новое место"
		
	@Parameter(title: "Название места", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var placeName: String
	
	@Parameter(title: "Название категории", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var categoryName: String
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let placeService = await AppFactory.providePlaceService()
		let categoryService = await AppFactory.provideCategoryService()
		let searchService = await AppFactory.provideSearchService()
		guard let category = categoryService.getCategory(by: categoryName) else {
			return .result(dialog: "Не получилось найти категорию \(categoryName) и добавить место")
		}
		
		let place = placeService.createPlace(name: placeName, category: category)
		searchService.index(place: place, image: nil)
		return .result(dialog: "Новое место \(placeName) добавлено!")
	}
}
