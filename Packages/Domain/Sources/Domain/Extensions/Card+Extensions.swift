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
			"\(Int(cashback.percent * 100))% \(cashback.category.name)"
		}.joined(separator: ", ")
	}
}
