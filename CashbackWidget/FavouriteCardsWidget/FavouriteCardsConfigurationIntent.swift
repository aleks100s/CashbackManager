//
//  FavouriteCardsConfigurationIntent.swift
//  CashbackManager
//
//  Created by Alexander on 19.01.2025.
//

import AppIntents

struct FavouriteCardsConfigurationIntent: WidgetConfigurationIntent {
	static var title: LocalizedStringResource = "Любимые карты"
	static var description: LocalizedStringResource = "Показать список любимых карт"
	
	static var parameterSummary: some ParameterSummary {
		Summary {
			\.$card1
			\.$card2
			\.$card3
		}
	}
	
	@Parameter(title: "Первая карта")
	var card1: Card?
	
	@Parameter(title: "Вторая карта")
	var card2: Card?
	
	@Parameter(title: "Третья карта")
	var card3: Card?
}

extension Card: AppEntity {
	struct CardQuery: EntityQuery {
		init() {}
		
		func entities(for identifiers: [Card.ID]) async throws -> [Card] {
			let cardsService = await AppFactory.provideCardsService()
			var cards = [Card]()
			for identifier in identifiers {
				if let card = await cardsService.getCard(id: identifier) {
					cards.append(card)
				}
			}
			return cards
		}
		
		func suggestedEntities() async throws -> [Card] {
			await AppFactory.provideCardsService().getAllCards()
		}
		
		func defaultResult() async -> Card? {
			try? await suggestedEntities().first
		}
	}
	
	static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Карта")
	static var defaultQuery = CardQuery()
	
	var displayRepresentation: DisplayRepresentation {
		DisplayRepresentation(title: "\(name)")
	}
}
