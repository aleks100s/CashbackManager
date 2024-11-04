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
	static var description: IntentDescription? = "Запрашивает заведение и выдает список карт с кэшбэком в нем"
	
	@Parameter(title: "Место")
	private var placeEntity: PlaceEntity?
	
	@Dependency
	private var placeService: PlaceService
	
	@Dependency
	private var cardsService: CardsService
	
	@Dependency
	private var categoryService: CategoryService
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let result = try await Task { @MainActor in
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
			
			let cards = cardsService.getCards(category: place.category)
			if !cards.isEmpty {
				return "Для оплаты в \(place.name) используйте карты: \(cards.map(\.name).joined(separator: ", "))"
			} else {
				return "Не удалось найти подходящие карты с категорией \(place.category.name)"
			}
		}.value
		return .result(dialog: "\(result)")
	}
}
