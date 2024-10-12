//
//  CreateIncomeIntent.swift
//  CashbackManager
//
//  Created by Alexander on 12.10.2024.
//

import AppIntents
import IncomeService

struct CreateIncomeIntent: AppIntent {
	static var title: LocalizedStringResource = "Выплата кэшбэка"
	static var description: IntentDescription? = "Запрашивает размер выплаты и сохраняет ее в приложении"
	
	@Parameter(title: "Размер выплаты", inputOptions: String.IntentInputOptions(keyboardType: .numberPad))
	var amount: String
	
	@Dependency
	private var incomeService: IncomeService
	
	init(amount: String) {
		self.amount = amount
	}
	
	init() {}
	
	func perform() async throws -> some ProvidesDialog {
		let amount = Int(self.amount) ?? .zero
		guard amount > 0 else {
			return .result(dialog: "Размер выплаты не может быть отрицательным или равным 0")
		}
		
		incomeService.createIncome(amount: amount)
		return .result(dialog: "Выплата кэшбэка в размере \(amount) рублей добавлена!")
	}
}
