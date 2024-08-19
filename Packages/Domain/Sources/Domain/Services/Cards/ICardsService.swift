//
//  ICashbackService.swift
//  CashbackManager
//
//  Created by Alexander on 17.06.2024.
//

import Foundation

public protocol ICardsService {
	func createCard(name: String) -> Card
	func getCard(id: UUID) -> Card?
	func getCard(name: String) -> Card?
	func getAllCards() -> [Card]
	func getCards(categoryName: String) -> [Card]
	func delete(card: Card)
}
