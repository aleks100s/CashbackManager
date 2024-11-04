//
//  Category.swift
//  CashbackManager
//
//  Created by Alexander on 14.06.2024.
//

import Foundation
import SwiftData

@Model
public final class Category: @unchecked Sendable {
	public var id: UUID
	public var name: String
	public var emoji: String
	public var synonyms: String?
	public var priority: Int
	public var isArchived: Bool = false
	
	public init(id: UUID = UUID(), name: String, emoji: String, synonyms: String? = nil, priority: Int = 0) {
		self.id = id
		self.name = name
		self.emoji = emoji
		self.synonyms = synonyms
		self.priority = priority
	}
	
//	private enum CodingKeys: String, CodingKey {
//		case id
//		case name
//		case emoji
//		case synonyms
//		case priority
//	}
//	
//	// Инициализатор Decodable
//	public required init(from decoder: Decoder) throws {
//		let container = try decoder.container(keyedBy: CodingKeys.self)
//		id = try container.decode(UUID.self, forKey: .id)
//		name = try container.decode(String.self, forKey: .name)
//		emoji = try container.decode(String.self, forKey: .emoji)
//		synonyms = try container.decodeIfPresent(String.self, forKey: .synonyms)
//		priority = try container.decode(Int.self, forKey: .priority)
//	}
//	
//	// Метод Encodable
//	public func encode(to encoder: Encoder) throws {
//		var container = encoder.container(keyedBy: CodingKeys.self)
//		try container.encode(id, forKey: .id)
//		try container.encode(name, forKey: .name)
//		try container.encode(emoji, forKey: .emoji)
//		try container.encodeIfPresent(synonyms, forKey: .synonyms)
//		try container.encode(priority, forKey: .priority)
//	}
}
