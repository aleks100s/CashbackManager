//
//  Category+Arbitrary.swift
//  CashbackManager
//
//  Created by Alexander on 14.06.2024.
//

import Foundation

extension Category {
	static let allPurchases = PredefinedCategory.allPurchases.asCategory
	static let entertainment = PredefinedCategory.entertainment.asCategory
	static let fastfood = PredefinedCategory.fastfood.asCategory
	static let restaurants = PredefinedCategory.restaurants.asCategory
	static let taxi = PredefinedCategory.taxi.asCategory
	
	static func arbitrary(predefinedCategory: PredefinedCategory = .allPurchases) -> Category {
		predefinedCategory.asCategory
	}
	
	static func arbitrary(
		name: String = UUID().uuidString,
		emoji: String = "🛒"
	) -> Category {
		Category(name: name, emoji: emoji)
	}
}
