//
//  CardEntity.swift
//  CashbackManager
//
//  Created by Alexander on 13.10.2024.
//

import AppIntents
import CardsService
import Domain

struct CardEntity: AppEntity {
	static var typeDisplayRepresentation: TypeDisplayRepresentation = "Card Entity"
	
	let id: UUID
	let card: Card
	
	var displayRepresentation: DisplayRepresentation {
		DisplayRepresentation(stringLiteral: card.name)
	}
	
	static var defaultQuery = CardQuery()
}

struct CardQuery: EntityQuery {
	@Dependency
	private var cardsService: CardsService
	
	func entities(for identifiers: [UUID]) async throws -> [CardEntity] {
		await cardsService.getAllCards().map {
			CardEntity(id: $0.id, card: $0)
		}
	}
}
