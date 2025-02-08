//
//  PredefinedCategory+Category.swift
//  CashbackManager
//
//  Created by Alexander on 17.06.2024.
//

extension PredefinedCategory {
	var asCategory: Category {
		Category(name: name, emoji: emoji, synonyms: synonyms.joined(separator: ","), info: info)
	}
}
