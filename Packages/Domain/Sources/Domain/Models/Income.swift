//
//  File.swift
//  Domain
//
//  Created by Alexander on 11.10.2024.
//

import Foundation
import SwiftData

@Model
public final class Income: @unchecked Sendable, Codable {
	public var id: UUID
	public var amount: Int
	public var date: Date
	public var source: Card?
	
	public init(id: UUID = UUID(), amount: Int, date: Date, source: Card?) {
		self.id = id
		self.amount = amount
		self.date = date
		self.source = source
	}
	
	// Ключи для кодирования и декодирования
	private enum CodingKeys: String, CodingKey {
		case id
		case amount
		case date
		case source
	}
	
	// Инициализатор Decodable
	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(UUID.self, forKey: .id)
		amount = try container.decode(Int.self, forKey: .amount)
		date = try container.decode(Date.self, forKey: .date)
		source = try container.decodeIfPresent(Card.self, forKey: .source)
	}
	
	// Метод Encodable
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(amount, forKey: .amount)
		try container.encode(date, forKey: .date)
		try container.encodeIfPresent(source, forKey: .source)
	}
}
