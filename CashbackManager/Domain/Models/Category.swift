//
//  Category.swift
//  CashbackManager
//
//  Created by Alexander on 14.06.2024.
//

import Foundation
import SwiftData

@Model
final class Category: @unchecked Sendable {
	var id: UUID
	var name: String
	var emoji: String
	var synonyms: String?
	var priority: Int
	var isArchived: Bool = false
	var info: String?
	
	init(
		id: UUID = UUID(),
		name: String,
		emoji: String,
		synonyms: String? = nil,
		priority: Int = 0,
		isArchived: Bool = false,
		info: String? = nil
	) {
		self.id = id
		self.name = name
		self.emoji = emoji
		self.synonyms = synonyms
		self.priority = priority
		self.isArchived = isArchived
		self.info = info
	}
}
