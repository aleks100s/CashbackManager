//
//  CheckPlaceCategoryIntent.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import Domain
import SwiftData

struct CheckPlaceCategoryIntent: AppIntent {
	static var title: LocalizedStringResource = "Какая категория в заведении?"
	
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
			return .result(dialog: "\(place.category.name)")
		} else {
			return .result(dialog: "Не удалось найти заведение \(placeName)")
		}
	}
}
