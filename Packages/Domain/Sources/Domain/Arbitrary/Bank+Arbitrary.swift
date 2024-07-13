//
//  Bank+Arbitrary.swift
//  CashbackManager
//
//  Created by Alexander on 11.06.2024.
//

import Foundation

public extension Bank {
	static let alphabank = arbitrary(name: "Alpha-bank")
	static let sberbank = arbitrary(name: "Сбербанк", cards: [.sberCard])
	static let tinkoffBank = arbitrary(name: "Tinkoff Bank", cards: [.tinkoffBlack, .tinkoffAllAirlines])
	
	static func arbitrary(
		name: String = UUID().uuidString,
		cards: [Card] = []
	) -> Bank {
		Bank(name: name, cards: cards)
	}
}
