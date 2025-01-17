//
//  Cashback.swift
//  CashbackManager
//
//  Created by Alexander on 11.06.2024.
//

import Foundation
import SwiftData

@Model
public final class Cashback {
	public var id: UUID
	public var category: Category
	public var percent: Double
	
	public var description: String {
		if (percent * 1000).truncatingRemainder(dividingBy: 10) == 0 {
			"\(category.name) \(Int(percent * 100))%"
		} else {
			"\(category.name) \(String(format: "%.1f", percent * 100))%"
		}
	}
	
	public init(id: UUID = UUID(), category: Category, percent: Double) {
		self.id = id
		self.category = category
		self.percent = percent
	}
	
//	// Ключи для кодирования и декодирования
//	private enum CodingKeys: String, CodingKey {
//		case id
//		case category
//		case percent
//	}
//	
//	// Инициализатор Decodable
//	public required init(from decoder: Decoder) throws {
//		let container = try decoder.container(keyedBy: CodingKeys.self)
//		id = try container.decode(UUID.self, forKey: .id)
//		category = try container.decode(Category.self, forKey: .category)
//		percent = try container.decode(Double.self, forKey: .percent)
//	}
//	
//	// Метод Encodable
//	public func encode(to encoder: Encoder) throws {
//		var container = encoder.container(keyedBy: CodingKeys.self)
//		try container.encode(id, forKey: .id)
//		try container.encode(category, forKey: .category)
//		try container.encode(percent, forKey: .percent)
//	}
}
