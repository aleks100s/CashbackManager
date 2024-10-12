//
//  CreateIncomeIntent.swift
//  CashbackManager
//
//  Created by Alexander on 12.10.2024.
//

import AppIntents
import CardsService
import IncomeService

struct CreateIncomeIntent: AppIntent {
	static var title: LocalizedStringResource = "Выплата кэшбэка"
	static var description: IntentDescription? = "Запрашивает размер выплаты и сохраняет ее в приложении"
	
	@Parameter(title: "Размер выплаты в рублях", inputOptions: String.IntentInputOptions(keyboardType: .numberPad))
	var amount: String
	
	@Parameter(title: "Источник выплаты")
	var source: IncomeEntity?
	
	@Dependency
	private var incomeService: IncomeService
	
	@Dependency
	private var cardsService: CardsService
	
	init(amount: String) {
		self.amount = amount
	}
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let amount = Int(self.amount) ?? .zero
		guard amount > 0 else {
			return .result(dialog: "Размер выплаты не может быть отрицательным или равным 0")
		}
		
		if let source {
			incomeService.createIncome(amount: amount, source: source.name, color: source.color)
		} else {
			let variants = cardsService.getAllCards().map {
				IncomeEntity(id: $0.id, name: $0.name, color: $0.color)
		 }
			let source = try await $source.requestDisambiguation(
				among: variants,
				dialog: IntentDialog(stringLiteral: "Выберите источник выплаты")
			)
			incomeService.createIncome(amount: amount, source: source.name, color: source.color)
		}
		
		return .result(dialog: "Выплата кэшбэка в размере \(amount) рублей добавлена!")
	}
}

struct IncomeEntity: AppEntity {
	static var typeDisplayRepresentation: TypeDisplayRepresentation = "Income Entity"
	
	let id: UUID
	let name: String
	let color: String?
	
	var displayRepresentation: DisplayRepresentation {
		DisplayRepresentation(stringLiteral: name)
	}
	
	static var defaultQuery = IncomeQuery()
}

struct IncomeQuery: EntityQuery {
	@Dependency
	private var cardsService: CardsService
	
	func entities(for identifiers: [UUID]) async throws -> [IncomeEntity] {
		cardsService.getAllCards().map {
			IncomeEntity(id: $0.id, name: $0.name, color: $0.color)
		}
	}
}
