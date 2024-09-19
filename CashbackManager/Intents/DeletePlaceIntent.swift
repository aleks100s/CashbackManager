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
	
	@Dependency
	private var searchService: SearchService
	
	init() {}
	
	init(placeName: String) {
		self.placeName = placeName
	}
	
	func perform() async throws -> some ProvidesDialog {
		guard let place = placeService.getPlace(by: placeName) else {
			return .result(dialog: "Не получилось найти место \(placeName)")
		}
		
		placeService.delete(place: place)
		searchService.deindex(place: place)
		return .result(dialog: "Место \"\(place.name)\" удалено!")
	}
}
