//
//  CashbackApp.swift
//  CashbackApp
//
//  Created by Alexander on 11.06.2024.
//

import Foundation

struct Cashback: Model {
	let id: UUID
	let category: Category
	let percent: Double
	
	init(id: UUID = UUID(), category: Category, percent: Double) {
		self.id = id
		self.category = category
		self.percent = percent
	}
}
