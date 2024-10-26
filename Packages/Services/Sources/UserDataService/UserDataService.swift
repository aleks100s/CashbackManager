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

public final class UserDataService {
	private let categoryService: CategoryService
	private let cardService: CardsService
	private let incomeService: IncomeService
	private let placeService: PlaceService
	
	public init(
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
				
		let fileURL = path.appendingPathComponent("exported.cashback")
		try data.write(to: fileURL)
		
		return fileURL
	}
}
