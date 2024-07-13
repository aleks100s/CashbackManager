//
//  Bank+Extensions.swift
//
//
//  Created by Alexander on 13.07.2024.
//

public extension Bank {
	var cardsList: String {
		cards.map(\.name).joined(separator: ", ")
	}
}
