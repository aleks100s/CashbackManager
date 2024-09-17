//
//  CheckPlaceCardIntent.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import CardsService
import CategoryService
import Domain
import PlaceService
import SwiftData

struct CheckPlaceCardIntent: AppIntent {
	static var title: LocalizedStringResource = "Карта в заведении"
	static var description: IntentDescription? = "Запрашивает название заведения и выдает список карт с кэшбэком в нем"
	
	@Parameter(title: "Название заведения", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var placeName: String
	
	@Dependency
	private var placeService: PlaceService
	
	@Dependency
	private var cardsService: CardsService
	
	@Dependency
	private var categoryService: CategoryService
	
	init(placeName: String) {
		self.placeName = placeName
	}
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		guard let place = placeService.getPlace(by: placeName) else {
			return .result(dialog: "Не удалось найти заведение \(placeName)")
		}
		
		let cards = cardsService.getCards(category: place.category)
		if !cards.isEmpty {
			return .result(dialog: "Для оплаты в \(placeName) используйте карты: \(cards.map(\.name).joined(separator: ", "))")
		} else {
			return .result(dialog: "Не удалось найти подходящие карты с категорией \(place.category.name)")
		}
	}
}
