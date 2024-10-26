//
//  SettingsModel.swift
//  CashbackManager
//
//  Created by Alexander on 26.10.2024.
//

import CardsService
import CategoryService
import Domain
import Foundation
import IncomeService
import PlaceService
import SwiftUI

private struct UserDataServiceKey: EnvironmentKey {
	static let defaultValue: UserDataService? = nil
}

extension EnvironmentValues {
	var userDataService: UserDataService? {
		get { self[UserDataServiceKey.self] }
		set { self[UserDataServiceKey.self] = newValue }
	}
}

final class UserDataService {
	private let categoryService: CategoryService
	private let cardService: CardsService
	private let incomeService: IncomeService
	private let placeService: PlaceService
	
	init(
		categoryService: CategoryService,
		cardService: CardsService,
		incomeService: IncomeService,
		placeService: PlaceService
	) {
		self.categoryService = categoryService
		self.cardService = cardService
		self.incomeService = incomeService
		self.placeService = placeService
	}
	
	func generateExportFile() async throws -> URL {
		let categories = categoryService.getAllCategories()
		let cards = cardService.getAllCards()
		let places = placeService.getAllPlaces()
		let payments = try await incomeService.fetchAll()
		let userData = UserData(categories: categories, cards: cards, places: places, payments: payments)
		
		let encoder = JSONEncoder()
		let data = try encoder.encode(userData)
				
		let path = try FileManager.default.url(
			for: .documentDirectory,
			in: .allDomainsMask,
			appropriateFor: nil,
			create: false
		)
				
		let fileURL = path.appendingPathComponent("exported.cashback")
		try data.write(to: fileURL)
		
		return fileURL
	}
}

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
