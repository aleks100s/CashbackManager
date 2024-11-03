//
//  DeletePlaceIntent.swift
//  CashbackManager
//
//  Created by Alexander on 28.08.2024.
//

import AppIntents
import PlaceService
import SearchService

struct DeletePlaceIntent: AppIntent {
	static var title: LocalizedStringResource = "Удалить место"
	static var description: IntentDescription? = "Удаляет место по названию"
		
	@Parameter(title: "Название места", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var placeName: String
	
	@Dependency
	private var placeService: PlaceService
	
	init() {}
	
	init(placeName: String) {
		self.placeName = placeName
	}
	
	func perform() async throws -> some ProvidesDialog {
		let result = await Task { @MainActor in
			guard let place = placeService.getPlace(by: placeName) else {
				return "Не получилось найти место \(placeName)"
			}
			
			placeService.delete(place: place)
			return "Место \"\(place.name)\" удалено!"
		}.value
		return .result(dialog: "\(result)")
	}
}
