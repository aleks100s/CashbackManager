//
//  CheckCardCashbackIntent.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import CardsService
import Domain
import SwiftData

struct CheckCardCashbackIntent: AppIntent {
	static var title: LocalizedStringResource = "Кэшбэк на карте"
	static var description: IntentDescription? = "Запрашивает имя карты и выдает кэшбэки по ней"
	
	@Parameter(title: "Карта")
	private var cardEntity: CardEntity?
	
	@Dependency
	private var cardsService: CardsService
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
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
		return .result(dialog: "\(card.cashbackDescription)")
	}
}

