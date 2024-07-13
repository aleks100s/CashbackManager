//
//  Cashback+Arbitrary.swift
//  CashbackManager
//
//  Created by Alexander on 11.06.2024.
//

public extension Cashback {
	static func arbitrary(
		category: Category = .arbitrary(),
		percent: Double = Double.random(in: 0.01...0.05)
	) -> Cashback {
		Cashback(category: category, percent: percent)
	}
	
	static func arbitrary(
		predefinedCategory: PredefinedCategory = .allPurchases,
		percent: Double = Double.random(in: 0.01...0.05)
	) -> Cashback {
		Cashback(category: predefinedCategory.asCategory, percent: percent)
	}
}
