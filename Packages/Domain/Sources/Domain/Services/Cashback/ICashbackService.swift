//
//  ICashbackService.swift
//  CashbackManager
//
//  Created by Alexander on 17.06.2024.
//

import Foundation

public protocol ICashbackService {
	func getCards() -> [Card]
	func save(card: Card)
	func update(card: Card)
	func delete(card: Card)
	func getCard(by id: UUID) -> Card?
	func save(currentCard: Card)
	func getCurrentCard() -> Card?
}
