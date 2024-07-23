//
//  Card+Extensions.swift
//  
//
//  Created by Alexander on 13.07.2024.
//

public extension Card {
	var cashbackDescription: String {
		guard !cashback.isEmpty else { return "Нет кэшбека" }
		
		return categoriesList
	}
	
	private var categoriesList: String {
		cashback.map { cashback in
			if (cashback.percent * 1000).truncatingRemainder(dividingBy: 10) == 0 {
				"\(Int(cashback.percent * 100))% \(cashback.category.name)"
			} else {
				"\(String(format: "%.1f", cashback.percent * 100))% \(cashback.category.name)"
			}
		}.joined(separator: ", ")
	}
}
