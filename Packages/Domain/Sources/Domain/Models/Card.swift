//
//  Card.swift
//  CashbackManager
//
//  Created by Alexander on 14.06.2024.
//

import Foundation
import SwiftData

@Model
public final class Card {
	public let id: UUID
	public var name: String
	@Relationship(deleteRule: .cascade)
	public var cashback: [Cashback]
	
	public var sortedCashback: [Cashback] {
		cashback.sorted(by: { $0.category.name < $1.category.name })
	}

	public init(id: UUID = UUID(), name: String, cashback: [Cashback] = []) {
		self.id = id
		self.name = name
		self.cashback = cashback
	}
}
