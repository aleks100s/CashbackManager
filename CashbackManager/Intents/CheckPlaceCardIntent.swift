//
//  CheckPlaceCardIntent.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import CardsService
import Domain
import SwiftData

struct CheckPlaceCardIntent: AppIntent {
	static var title: LocalizedStringResource = "Карта в заведении"
	static var description: IntentDescription? = "Запрашивает название заведения и выдает список карт с кэшбеком в нем"
	
	@Parameter(title: "Название заведения", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var placeName: String
	
	init(placeName: String) {
		self.placeName = placeName
	}
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let container = AppFactory.provideModelContainer()
		let context = ModelContext(container)
		let predicate = #Predicate<Place> { $0.name.localizedStandardContains(placeName) }
		let descriptor = FetchDescriptor(predicate: predicate)
		if let place = (try? context.fetch(descriptor))?.first {
			let service = CardsService(context: context)
			let cards = service.getCards(categoryName: place.category.name)
			if !cards.isEmpty {
				return .result(dialog: "\(cards.map(\.name).joined(separator: ", "))")
			} else {
				return .result(dialog: "Не удалось найти подходящие карты с категорией \(place.category.name)")
			}
		} else {
			return .result(dialog: "Не удалось найти заведение \(placeName)")
		}
	}
}
