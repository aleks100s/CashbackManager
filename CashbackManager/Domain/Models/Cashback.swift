//
//  Cashback.swift
//  CashbackManager
//
//  Created by Alexander on 11.06.2024.
//

import Foundation
import SwiftData

@Model
final class Cashback {
	var id: UUID
	var category: Category
	var percent: Double
	
	var description: String {
		if (percent * 1000).truncatingRemainder(dividingBy: 10) == 0 {
			"\(category.name) \(Int(percent * 100))%"
		} else {
			"\(category.name) \(String(format: "%.1f", percent * 100))%"
		}
	}
	
	init(id: UUID = UUID(), category: Category, percent: Double) {
		self.id = id
		self.category = category
		self.percent = percent
	}
}
