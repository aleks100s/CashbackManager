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
import SearchService
import Shared

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
		let fileManager = FileManager.default
		guard let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
			throw UserDataError.cachesDirectoryNotFound
		}
		
		let destinationURL = cachesDirectory.appendingPathComponent(UUID().uuidString)
		try fileManager.copyItem(at: url, to: destinationURL)
		
		let data = try Data(contentsOf: destinationURL)
		let jsonDecoder = JSONDecoder()
		let userData = try jsonDecoder.decode(UserDataDto.self, from: data)
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
		let categories = userData.categories
			.map { Domain.Category(id: $0.id, name: $0.name, emoji: $0.emoji, synonyms: $0.synonyms, priority: $0.priority) }
		categoryService.insert(categories: categories)
		
		
		let places = userData.places
			.compactMap { dto -> Place? in
				guard let category = categories.first(where: { $0.id == dto.category.id }) else {
					return nil
				}
				
				return Place(id: dto.id, name: dto.name, category: category)
			}
		placeService.insert(places: places)
		for place in places {
			searchService.index(place: place)
		}
		
		
		let cards = userData.cards
			.map { dto in
				return Card(
					id: dto.id,
					name: dto.name,
					cashback: dto.cashback.compactMap { cashback in
						guard let category = categories.first(where: { $0.id == cashback.category.id }) else {
							return nil
						}
						return Cashback(
							id: cashback.id,
							category: category,
							percent: cashback.percent
						)
					},
					color: dto.color
				)
			}
		cardService.insert(cards: cards)
		for card in cards {
			searchService.index(card: card)
		}
		
		
		let payments = userData.payments
			.map { dto in
				let card = cards.first(where: { $0.id == dto.source?.id })
				return Income(
					id: dto.id,
					amount: dto.amount,
					date: dto.date,
					source: card
				)
			}
		incomeService.insert(transactions: payments)
		await MainActor.run {
			NotificationCenter.default.post(name: Constants.resetAppNavigationNotification, object: nil)
		}
	}
}

private struct CategoryDto: Codable {
	public var id: UUID
	public var name: String
	public var emoji: String
	public var synonyms: String?
	public var priority: Int
}

private struct PlaceDto: Codable {
	public var id: UUID
	public var name: String
	public var category: CategoryDto
}

private struct CashbackDto: Codable {
	public var id: UUID
	public var category: CategoryDto
	public var percent: Double
}

private struct CardDto: Codable {
	public var id: UUID
	public var name: String
	public var cashback: [CashbackDto]
	public var color: String?
}

private struct IncomeDto: Codable {
	public var id: UUID
	public var amount: Int
	public var date: Date
	public var source: CardDto?
}

private struct UserDataDto: Codable {
	let categories: [CategoryDto]
	let cards: [CardDto]
	let places: [PlaceDto]
	let payments: [IncomeDto]
}
