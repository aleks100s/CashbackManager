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
	static var description: IntentDescription? = "Запрашивает название заведения и выдает его категорию кэшбека"
	
	@Parameter(title: "Название заведения", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var placeName: String
	
	@Dependency
	private var placeService: PlaceService
	
	init(placeName: String) {
		self.placeName = placeName
	}
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let placeService = await AppFactory.providePlaceService()
		if let place = placeService.getPlace(by: placeName) {
			return .result(dialog: "\(placeName) относится к категории \(place.category.name)")
		} else {
			return .result(dialog: "Не удалось найти заведение \(placeName)")
		}
	}
}
