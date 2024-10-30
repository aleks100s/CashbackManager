//
//  Card.swift
//  CashbackManager
//
//  Created by Alexander on 14.06.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
public final class Card: @unchecked Sendable {
	public var id: UUID
	public var name: String
	@Relationship(deleteRule: .cascade)
	public var cashback: [Cashback]
	public var color: String?
	public var isArchived: Bool = false
	
	public var sortedCashback: [Cashback] {
		cashback.sorted(by: { $0.category.name < $1.category.name })
	}
	
	public var cashbackDescription: String {
		guard !cashback.isEmpty else { return "Нет кэшбэка" }
		
		return categoriesList
	}
	
	public var isEmpty: Bool {
		cashback.isEmpty
	}
	
	private var categoriesList: String {
		sortedCashback.map(\.description).joined(separator: ", ")
	}

	public init(id: UUID = UUID(), name: String, cashback: [Cashback] = [], color: String?) {
		self.id = id
		self.name = name
		self.cashback = cashback
		self.color = color
	}
	
	public func has(category: Category?) -> Bool {
		guard let category else { return false }
		
		return cashback.map(\.category.id).contains(category.id)
	}
	
//	// Ключи для кодирования и декодирования
//	private enum CodingKeys: String, CodingKey {
//		case id
//		case name
//		case cashback
//		case color
//	}
//	
//	// Инициализатор Decodable
//	public required init(from decoder: Decoder) throws {
//		let container = try decoder.container(keyedBy: CodingKeys.self)
//		id = try container.decode(UUID.self, forKey: .id)
//		name = try container.decode(String.self, forKey: .name)
//		cashback = try container.decode([Cashback].self, forKey: .cashback)
//		color = try container.decodeIfPresent(String.self, forKey: .color)
//	}
//	
//	// Метод Encodable
//	public func encode(to encoder: Encoder) throws {
//		var container = encoder.container(keyedBy: CodingKeys.self)
//		try container.encode(id, forKey: .id)
//		try container.encode(name, forKey: .name)
//		try container.encode(cashback, forKey: .cashback)
//		try container.encodeIfPresent(color, forKey: .color)
//	}
}
