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
	static var description: IntentDescription? = "Добавляет новое место и ассоциирует категорию кэшбэка"
		
	@Parameter(title: "Название места", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var placeName: String
	
	@Parameter(title: "Категория")
	private var categoryEntity: CategoryEntity?
	
	@Dependency
	private var placeService: PlaceService
	
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
			
			placeService.createPlace(name: placeName, category: category)
			return "Новое место \(placeName) добавлено!"
		}.value
		return .result(dialog: "\(result)")
	}
}
