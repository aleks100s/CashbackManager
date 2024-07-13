//
//  Bank.swift
//  CashbackManager
//
//  Created by Alexander on 11.06.2024.
//

import Foundation

public struct Bank: Model {
	public let id: UUID
	public var name: String
	public var cards: [Card]
	
	public init(id: UUID = UUID(), name: String, cards: [Card] = []) {
		self.id = id
		self.name = name
		self.cards = cards
	}
}
