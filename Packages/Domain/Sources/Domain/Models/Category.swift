//
//  Category.swift
//  CashbackManager
//
//  Created by Alexander on 14.06.2024.
//

import Foundation
import SwiftData

@Model
public final class Category {
	public var id: UUID
	public var name: String
	public var emoji: String
	public var synonyms: String?
	public var priority: Int
	
	public init(id: UUID = UUID(), name: String, emoji: String, synonyms: String? = nil, priority: Int = 0) {
		self.id = id
		self.name = name
		self.emoji = emoji
		self.synonyms = synonyms
		self.priority = priority
	}
}
