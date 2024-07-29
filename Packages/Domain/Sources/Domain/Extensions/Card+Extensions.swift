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
		cashback.map(\.description).joined(separator: ", ")
	}
}
