//
//  CardsService.swift
//  CashbackManager
//
//  Created by Alexander on 26.07.2024.
//

import Domain
import Foundation
import SwiftData

public struct CardsService: ICardsService {
	private let context: ModelContext
	
	public init(context: ModelContext) {
		self.context = context
	}
	
	public func getCard(by id: UUID) -> Card? {
		let predicate = #Predicate<Card> { $0.id == id }
		let descriptor = FetchDescriptor(predicate: predicate)
		return try? context.fetch(descriptor).first
	}
	
	public func getAllCards() -> [Card] {
		let allCardsPredicate = #Predicate<Card> { !$0.cashback.isEmpty }
		let allCardsDescriptor = FetchDescriptor(predicate: allCardsPredicate)
		return (try? context.fetch(allCardsDescriptor)) ?? []
	}
}
