//
//  Card.swift
//  CashbackManager
//
//  Created by Alexander on 14.06.2024.
//

import Foundation

public struct Card: Model {
	public let id: UUID
	public var name: String
	public var cashback: [Cashback]

	public init(id: UUID = UUID(), name: String, cashback: [Cashback] = []) {
		self.id = id
		self.name = name
		self.cashback = cashback
	}
}
