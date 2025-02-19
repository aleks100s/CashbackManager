//
//  CreateCardIntent.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import SwiftData

struct CreateCardIntent: AppIntent {
	static var title: LocalizedStringResource = "Новая карта"
	static var description: IntentDescription? = "Запрашивает имя для новой карты и сохраняет ее в приложении"
	
	@Parameter(title: "Название карты", inputOptions: String.IntentInputOptions(keyboardType: .default))
	var cardName: String
	
	@Dependency
	private var cardsService: CardsService
	
	init(cardName: String) {
		self.cardName = cardName
	}
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let result = await Task { @MainActor in
			if cardName.isEmpty {
				cardName = "Карта"
			}
			cardsService.createCard(name: cardName)
			return "Новая карта \"\(cardName)\" создана"
		}.value
		return .result(dialog: "\(result)")
	}
}
