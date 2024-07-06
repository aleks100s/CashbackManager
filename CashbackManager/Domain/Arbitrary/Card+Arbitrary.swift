//
//  Card+Arbitrary.swift
//  CashbackManager
//
//  Created by Alexander on 14.06.2024.
//

import Foundation

extension Card {
	static let tinkoffBlack = Card(
		name: "Tinkoff Black",
		cashback: [
			.arbitrary(category: .allPurchases, percent: 0.01),
			.arbitrary(category: .entertainment, percent: 0.1),
			.arbitrary(category: .fastfood, percent: 0.05),
			.arbitrary(category: .restaurants, percent: 0.05),
			.arbitrary(category: .taxi, percent: 0.05)
		]
	)
	
	static let tinkoffAllAirlines = Card(
		name: "All Airlines",
		cashback: [.arbitrary(category: .allPurchases, percent: 0.02)]
	)
	
	static let sberCard = Card(
		name: "Сберкарта",
		cashback: [
			.arbitrary(category: .allPurchases, percent: 0.01),
			.arbitrary(category: .arbitrary(predefinedCategory: .supermarkets), percent: 0.015),
			.arbitrary(category: .arbitrary(predefinedCategory: .taxi), percent: 0.05),
			.arbitrary(category: .restaurants, percent: 0.05),
			.arbitrary(category: .arbitrary(predefinedCategory: .electronicDevices), percent: 0.03)
		]
	)
	
	static func arbitrary(
		name: String = UUID().uuidString,
		cashback: [Cashback] = []
	) -> Card {
		Card(name: name, cashback: cashback)
	}
}
