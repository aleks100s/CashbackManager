//
//  PredefinedCategory+Arbitrary.swift
//  CashbackManager
//
//  Created by Alexander on 11.06.2024.
//

extension PredefinedCategory {
	static func random() -> PredefinedCategory {
		PredefinedCategory.allCases.randomElement() ?? .allPurchases
	}
}

extension [PredefinedCategory] {
	static func arbitrary(count: Int = 5) -> [PredefinedCategory] {
		(0..<count).compactMap { _ in .random() }
	}
}
