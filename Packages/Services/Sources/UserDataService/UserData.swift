//
//  File.swift
//  Services
//
//  Created by Alexander on 27.10.2024.
//

import Domain

final class UserData: Codable {
	let categories: [Domain.Category]
	let cards: [Card]
	let places: [Place]
	let payments: [Income]
	
	init(categories: [Domain.Category], cards: [Card], places: [Place], payments: [Income]) {
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
		categories = try container.decode([Domain.Category].self, forKey: .categories)
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
