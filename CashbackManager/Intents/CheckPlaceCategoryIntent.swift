//
//  CheckPlaceCategoryIntent.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import Domain
import PlaceService
import SwiftData

struct CheckPlaceCategoryIntent: AppIntent {
	static var title: LocalizedStringResource = "Категория в заведении"
	static var description: IntentDescription? = "Запрашивает заведение и выдает его категорию кэшбэка"
	
	@Parameter(title: "Место")
	private var placeEntity: PlaceEntity?
	
	@Dependency
	private var placeService: PlaceService
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let result = try await Task { @MainActor in
			let placeService = AppFactory.providePlaceService()
			let place: Place
			if let placeEntity {
				place = placeEntity.place
			} else {
				let variants = placeService.getAllPlaces().map {
					PlaceEntity(id: $0.id, place: $0)
				}
				let placeEntity = try await $placeEntity.requestDisambiguation(
					among: variants,
					dialog: IntentDialog(stringLiteral: "Выберите место")
				)
				place = placeEntity.place
			}
			return "\(place.name) относится к категории \(place.category.name)"
		}.value
		return .result(dialog: "\(result)")
	}
}
