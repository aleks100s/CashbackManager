//
//  Card+Extensions.swift
//  
//
//  Created by Alexander on 13.07.2024.
//

public extension Card {
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
