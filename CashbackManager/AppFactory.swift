//
//  AppFactory.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import CardsService
import CategoryService
import Domain
import PlaceService
import SearchService
import SwiftData
import TextDetectionService

@MainActor
enum AppFactory {
	private static let container = try! ModelContainer(for: Card.self, Cashback.self, Domain.Category.self, Place.self, Income.self)
	private static let searchService = SearchService()
	private static let cardsService = CardsService(context: container.mainContext)
	private static let categoryService = CategoryService(context: container.mainContext)
	private static let placeService = PlaceService(context: container.mainContext)
	private static let textDetectionService = TextDetectionService()
	
	static func provideModelContainer() -> ModelContainer {
		container
	}
	
	static func provideSearchService() -> SearchService {
		searchService
	}
	
	@MainActor
	static func provideCardsService() -> CardsService {
		cardsService
	}
	
	@MainActor 
	static func provideCategoryService() -> CategoryService {
		categoryService
	}
	
	@MainActor
	static func providePlaceService() -> PlaceService {
		placeService
	}
	
	@MainActor
	static func provideTextDetectionService() -> TextDetectionService {
		textDetectionService
	}
}
