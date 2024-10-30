//
//  Place.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import Foundation
import SwiftData

@Model
public final class Place {
	public var id: UUID
	public var name: String
	public var category: Category
	
	public init(id: UUID = UUID(), name: String, category: Category) {
		self.id = id
		self.name = name
		self.category = category
	}
	
//	// Ключи для кодирования и декодирования
//	private enum CodingKeys: String, CodingKey {
//		case id
//		case name
//		case category
//	}
//	
//	// Инициализатор Decodable
//	public required init(from decoder: Decoder) throws {
//		let container = try decoder.container(keyedBy: CodingKeys.self)
//		id = try container.decode(UUID.self, forKey: .id)
//		name = try container.decode(String.self, forKey: .name)
//		category = try container.decode(Category.self, forKey: .category)
//	}
//	
//	// Метод Encodable
//	public func encode(to encoder: Encoder) throws {
//		var container = encoder.container(keyedBy: CodingKeys.self)
//		try container.encode(id, forKey: .id)
//		try container.encode(name, forKey: .name)
//		try container.encode(category, forKey: .category)
//	}
}
