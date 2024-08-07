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
	public let id: UUID
	public let name: String
	public let emoji: String
	public var priority: Int
	
	public init(id: UUID = UUID(), name: String, emoji: String, priority: Int = 0) {
		self.id = id
		self.name = name
		self.emoji = emoji
		self.priority = priority
	}
}
