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
	
	public init(id: UUID = UUID(), name: String, emoji: String) {
		self.id = id
		self.name = name
		self.emoji = emoji
	}
}
