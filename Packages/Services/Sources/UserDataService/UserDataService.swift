//
//  SettingsModel.swift
//  CashbackManager
//
//  Created by Alexander on 26.10.2024.
//

import CardsService
import CategoryService
import Foundation
import IncomeService
import PlaceService
import SearchService

public final class UserDataService {
	private let categoryService: CategoryService
	private let cardService: CardsService
	private let incomeService: IncomeService
	private let placeService: PlaceService
	private let searchService: SearchService
	
	public init(
		categoryService: CategoryService,
		cardService: CardsService,
		incomeService: IncomeService,
		placeService: PlaceService,
		searchService: SearchService
	) {
		self.categoryService = categoryService
		self.cardService = cardService
		self.incomeService = incomeService
		self.placeService = placeService
		self.searchService = searchService
	}
	
	public func generateExportFile() async throws -> URL {
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
				
		let fileURL = path.appendingPathComponent("exported.json")
		try data.write(to: fileURL)
		
		return fileURL
	}
	
	public func importData(from url: URL) async throws {
		let data = try Data(contentsOf: url)
		let jsonDecoder = JSONDecoder()
		let userData = try jsonDecoder.decode(UserData.self, from: data)
		// reset app
		for transaction in try await incomeService.fetchAll() {
			incomeService.delete(income: transaction)
		}
		for place in placeService.getAllPlaces() {
			searchService.deindex(place: place)
			placeService.delete(place: place)
		}
		for card in cardService.getAllCards() {
			searchService.deindex(card: card)
			cardService.delete(card: card)
		}
		for category in categoryService.getAllCategories() {
			categoryService.delete(category: category)
		}
		categoryService.insert(categories: userData.categories)
		cardService.insert(cards: userData.cards)
		placeService.insert(places: userData.places)
		incomeService.insert(transactions: userData.payments)
		for card in userData.cards {
			searchService.index(card: card)
		}
		for place in userData.places {
			searchService.index(place: place)
		}
	}
}
