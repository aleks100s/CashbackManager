//
//  ICashbackService.swift
//  CashbackManager
//
//  Created by Alexander on 17.06.2024.
//

import Foundation

protocol ICashbackService {
	func getBanks() -> [Bank]
	func save(bank: Bank)
	func update(banks: [Bank])
	func update(bank: Bank)
	func update(card: Card)
	func delete(card: Card)
	func getCard(by id: UUID) -> Card?
	func getBank(by id: UUID) -> Bank?
}
