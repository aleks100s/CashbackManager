//
//  ICashbackService.swift
//  CashbackManager
//
//  Created by Alexander on 17.06.2024.
//

import Foundation

public protocol ICardsService {
	func getCard(by id: UUID) -> Card?
	func getAllCards() -> [Card]
}
