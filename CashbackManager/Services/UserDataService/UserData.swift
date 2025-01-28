//
//  File.swift
//  Services
//
//  Created by Alexander on 27.10.2024.
//

import CoreTransferable

final class UserData: Codable, Transferable {
	static var transferRepresentation: some TransferRepresentation {
		DataRepresentation(exportedContentType: .data) { transerable in
			try JSONEncoder().encode(transerable)
		}
	}
	
	let categories: [Category]
	let cards: [Card]
	let places: [Place]
	let payments: [Income]
	
	init(categories: [Category], cards: [Card], places: [Place], payments: [Income]) {
		self.categories = categories
		self.cards = cards
		self.places = places
		self.payments = payments
	}
	
	// Ключи для кодирования и декодирования
	private enum CodingKeys: String, CodingKey {
		case categories
		case cards
		case places
		case payments
	}
	
	// Инициализатор Decodable
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		categories = try container.decode([Category].self, forKey: .categories)
		cards = try container.decode([Card].self, forKey: .cards)
		places = try container.decode([Place].self, forKey: .places)
		payments = try container.decode([Income].self, forKey: .payments)
	}
	
	// Метод Encodable
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(categories, forKey: .categories)
		try container.encode(cards, forKey: .cards)
		try container.encode(places, forKey: .places)
		try container.encode(payments, forKey: .payments)
	}
}

extension UserData {
	struct Category: Codable {
		var id: UUID
		var name: String
		var emoji: String
		var synonyms: String?
		var priority: Int
		var isArchived: Bool
	}
	
	struct Cashback: Codable {
		var id: UUID
		var category: Category
		var percent: Double
	}
	
	struct Card: Codable {
		var id: UUID
		var name: String
		var cashback: [Cashback]
		var color: String?
		var isArchived: Bool
		var isFavorite: Bool
		var currency: String
		var currencySymbol: String
	}
	
	struct Income: Codable {
		var id: UUID
		var amount: Int
		var date: Date
		var source: Card?
	}
	
	struct Place: Codable {
		var id: UUID
		var name: String
		var category: Category
		var isFavorite: Bool
	}
}
