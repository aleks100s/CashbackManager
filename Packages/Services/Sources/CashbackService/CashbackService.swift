//
//  CashbackService.swift
//  CashbackManager
//
//  Created by Alexander on 30.06.2024.
//

import Domain
import Foundation
import Persistance

public final class CashbackService: ICashbackService {
	private var cards: [Card] = [] {
		didSet {
			persistCards()
		}
	}
	
	
	public init() {}
	
	public func getCards() -> [Card] {
		cards
	}
	
	public func save(card: Card) {
		cards.append(card)
	}
	
	public func update(card: Card) {
		for i in cards.indices {
			if cards[i].id == card.id {
				cards[i] = card
				break
			}
		}
	}
	
	public func delete(card: Card) {
		cards.removeAll { $0.id == card.id }
	}
	
	public func getCard(by id: UUID) -> Card? {
		for card in cards {
			if card.id == id {
				return card
			}
		}
		return nil
	}
	
	public func save(currentCard: Card) {
		
	}
	
	public func getCurrentCard() -> Card? {
		nil
	}
	
	private func persistCards() {
	}
}
