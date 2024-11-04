//
//  DeleteCardIntent.swift
//  CashbackManager
//
//  Created by Alexander on 28.08.2024.
//

import AppIntents
import CardsService
import Domain

struct DeleteCardIntent: AppIntent {
	static var title: LocalizedStringResource = "Удалить карту"
	static var description: IntentDescription? = "Удаляет выбранную карту"
		
	@Parameter(title: "Карта")
	private var cardEntity: CardEntity?
	
	@Dependency
	private var cardsService: CardsService
	
	init() {}
	
	
	func perform() async throws -> some ProvidesDialog {
		let result = try await Task { @MainActor in
			let card: Card
			if let cardEntity {
				card = cardEntity.card
			} else {
				let variants = cardsService.getAllCards().map {
					CardEntity(id: $0.id, card: $0)
				}
				let cardEntity = try await $cardEntity.requestDisambiguation(
					among: variants,
					dialog: IntentDialog(stringLiteral: "Выберите карту")
				)
				card = cardEntity.card
			}
			
			cardsService.archive(card: card)
			return "Карта \"\(card.name)\" удалена!"
		}.value
		return .result(dialog: "\(result)")
	}
}
