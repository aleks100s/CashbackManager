//
//  DeletePlaceIntent.swift
//  CashbackManager
//
//  Created by Alexander on 28.08.2024.
//

import AppIntents
import Domain
import PlaceService

struct DeletePlaceIntent: AppIntent {
	static var title: LocalizedStringResource = "Удалить место"
	static var description: IntentDescription? = "Удаляет место"
		
	@Parameter(title: "Место")
	private var placeEntity: PlaceEntity?
	
	@Dependency
	private var placeService: PlaceService
	
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
			
			placeService.delete(place: place)
			return "Место \"\(place.name)\" удалено!"
		}.value
		return .result(dialog: "\(result)")
	}
}
