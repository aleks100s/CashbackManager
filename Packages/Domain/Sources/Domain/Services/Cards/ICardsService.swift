//
//  ICashbackService.swift
//  CashbackManager
//
//  Created by Alexander on 17.06.2024.
//

import Foundation

public protocol ICardsService {
	func createCard(name: String) -> Card
	func getCard(by id: UUID) -> Card?
	func getCard(by name: String) -> Card?
	func getAllCards() -> [Card]
}
