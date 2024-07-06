//
//  Bank.swift
//  CashbackApp
//
//  Created by Alexander on 11.06.2024.
//

import Foundation

struct Bank: Model {
	let id: UUID
	var name: String
	var cards: [Card]
	
	init(id: UUID = UUID(), name: String, cards: [Card] = []) {
		self.id = id
		self.name = name
		self.cards = cards
	}
}

extension Bank {
	var cardsList: String {
		cards.map(\.name).joined(separator: ", ")
	}
}
