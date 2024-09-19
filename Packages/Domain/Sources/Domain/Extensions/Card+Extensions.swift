//
//  Card+Extensions.swift
//  
//
//  Created by Alexander on 13.07.2024.
//

public extension Card {
	var cashbackDescription: String {
		guard !cashback.isEmpty else { return "Нет кэшбэка" }
		
		return categoriesList
	}
	
	func has(category: Category?) -> Bool {
		guard let category else { return false }
		
		return cashback.map(\.category).contains(category)
	}
	
	private var categoriesList: String {
		sortedCashback.map(\.description).joined(separator: ", ")
	}
}
