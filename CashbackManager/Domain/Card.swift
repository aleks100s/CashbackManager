//
//  Card.swift
//  CashbackApp
//
//  Created by Alexander on 14.06.2024.
//

import Foundation

struct Card: Model {
	let id: UUID
	var name: String
	var cashback: [Cashback]

	init(id: UUID = UUID(), name: String, cashback: [Cashback] = []) {
		self.id = id
		self.name = name
		self.cashback = cashback
	}
}

extension Card {
	var cashbackDescription: String {
		guard !cashback.isEmpty else { return "Нет кэшбека" }
		
		return "\(percentRange) \(categoriesList)"
	}
	
	private var categoriesList: String {
		cashback.map(\.category.name).joined(separator: ", ")
	}
	
	private var percentRange: String {
		let minPercent = cashback.min(by: { $0.percent < $1.percent })?.percent ?? .zero
		let maxPercent = cashback.max(by: { $0.percent < $1.percent })?.percent ?? .zero
		if minPercent == maxPercent {
			return "\(Int(minPercent * 100))%"
		} else {
			return "\(Int(minPercent * 100))-\(Int(maxPercent * 100))%"
		}
	}
}
