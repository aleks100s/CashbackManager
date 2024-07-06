//
//  Category.swift
//  CashbackManager
//
//  Created by Alexander on 14.06.2024.
//

struct Category: Model {
	let name: String
	let emoji: String
	
	var id: String {
		name
	}
}
