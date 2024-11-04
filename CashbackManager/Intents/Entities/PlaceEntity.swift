//
//  PlaceEntity.swift
//  CashbackManager
//
//  Created by Alexander on 13.10.2024.
//

import AppIntents
import Domain
import PlaceService

struct PlaceEntity: AppEntity {
	static var typeDisplayRepresentation: TypeDisplayRepresentation = "Place Entity"
	
	let id: UUID
	let place: Place
	
	var displayRepresentation: DisplayRepresentation {
		DisplayRepresentation(stringLiteral: place.name)
	}
	
	static var defaultQuery = PlaceQuery()
}

struct PlaceQuery: EntityQuery {
	@Dependency
	private var placeService: PlaceService
	
	func entities(for identifiers: [UUID]) async throws -> [PlaceEntity] {
		await placeService.getAllPlaces().map {
			PlaceEntity(id: $0.id, place: $0)
		}
	}
}
