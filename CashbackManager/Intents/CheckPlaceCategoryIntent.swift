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
	static var description: IntentDescription? = "Запрашивает название заведения и выдает его категорию кэшбэка"
	
	@Parameter(title: "Название заведения", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var placeName: String
	
	@Dependency
	private var placeService: PlaceService
	
	init(placeName: String) {
		self.placeName = placeName
	}
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let result = await Task { @MainActor in
			let placeService = AppFactory.providePlaceService()
			if let place = placeService.getPlace(by: placeName) {
				return "\(placeName) относится к категории \(place.category.name)"
			} else {
				return "Не удалось найти заведение \(placeName)"
			}
		}.value
		return .result(dialog: "\(result)")
	}
}
