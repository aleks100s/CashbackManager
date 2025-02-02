//
//  CreateIncomeIntent.swift
//  CashbackManager
//
//  Created by Alexander on 12.10.2024.
//

import AppIntents

struct CreateIncomeIntent: AppIntent {
	static var title: LocalizedStringResource = "Выплата кэшбэка"
	static var description: IntentDescription? = "Запрашивает размер выплаты и сохраняет ее в приложении"
	
	@Parameter(title: "Размер выплаты в рублях/милях/баллах", inputOptions: String.IntentInputOptions(keyboardType: .numberPad))
	var amount: String
	
	@Parameter(title: "Источник выплаты")
	var source: CardEntity?
	
	@Dependency
	private var incomeService: IncomeService
	
	@Dependency
	private var cardsService: CardsService
	
	init(amount: String) {
		self.amount = amount
	}
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let result = try await Task { @MainActor in
			let amount = Int(self.amount) ?? .zero
			guard amount > 0 else {
				return "Размер выплаты не может быть отрицательным или равным 0"
			}
			
			if let source {
				incomeService.createIncome(amount: amount, source: source.card)
			} else {
				let variants = cardsService.getAllCards().map {
					CardEntity(id: $0.id, card: $0)
			 }
				let source = try await $source.requestDisambiguation(
					among: variants,
					dialog: IntentDialog(stringLiteral: "Выберите источник выплаты")
				)
				incomeService.createIncome(amount: amount, source: source.card)
			}
			
			return "Выплата кэшбэка в размере \(amount) добавлен!"
		}.value
		return .result(dialog: "\(result)")
	}
}
