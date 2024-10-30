//
//  SettingsModel.swift
//  CashbackManager
//
//  Created by Alexander on 26.10.2024.
//

import CoreTransferable
import Domain
import Foundation
import SearchService
import Shared
import SwiftData

public final class UserDataService {
	private let searchService: SearchService
	
	public init(searchService: SearchService) {
		self.searchService = searchService
	}
	
	public func generateExportFile() async throws -> UserData {
		let context = try getContext()

		let categories: [Domain.Category] = try fetchAll(from: context)
		let places: [Place] = try fetchAll(from: context)
		let cards: [Card] = try fetchAll(from: context)
		let payments: [Income] = try fetchAll(from: context)
		
		let userData = UserData(categories: categories, cards: cards, places: places, payments: payments)
		return userData
	}
	
	public func importData(from url: URL) async throws {
		guard url.startAccessingSecurityScopedResource() else {
			throw UserDataError.noPermission
		}
		
		let context = try getContext()
		
		let data = try Data(contentsOf: url)
		let userData = try JSONDecoder().decode(UserData.self, from: data)
		
		try context.transaction {
			try deleteAll(from: context)
			for category in userData.categories {
				context.insert(category)
			}
			for place in userData.places {
				context.insert(place)
				searchService.index(place: place)
			}
			for card in userData.cards {
				context.insert(card)
				searchService.index(card: card)
			}
			for income in userData.payments {
				context.insert(income)
			}
		}
		
		try context.save()

//		await MainActor.run {
//			NotificationCenter.default.post(name: Constants.resetAppNavigationNotification, object: nil)
//		}
		url.stopAccessingSecurityScopedResource()
	}
	
	private func getContext() throws -> ModelContext {
		let container = try ModelContainer(for: Domain.Category.self, Place.self, Card.self, Income.self)
		return ModelContext(container)
	}
	
	func deleteAll(from context: ModelContext) throws {
		let payments: [Income] = try fetchAll(from: context)
		for payment in payments {
			context.delete(payment)
		}
		let cards: [Card] = try fetchAll(from: context)
		for card in cards {
			searchService.deindex(card: card)
			context.delete(card)
		}
		let places: [Place] = try fetchAll(from: context)
		for place in places {
			searchService.deindex(place: place)
			context.delete(place)
		}
		let categories: [Domain.Category] = try fetchAll(from: context)
		for category in categories {
			context.delete(category)
		}
	}
	
	private func fetchAll<T: PersistentModel>(from context: ModelContext) throws -> [T] {
		try context.fetch(FetchDescriptor<T>())
	}
}
