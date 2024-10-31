//
//  AppFactory.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import CardsService
import CategoryService
import Domain
import IncomeService
import NotificationService
import PlaceService
import SearchService
import SwiftData
import TextDetectionService
import UserDataService

@MainActor
enum AppFactory {
	private static let container = try! ModelContainer(for: Card.self, Cashback.self, Domain.Category.self, Place.self, Income.self)
	private static let searchService = SearchService()
	private static let cardsService = CardsService(context: container.mainContext)
	private static let categoryService = CategoryService(context: container.mainContext)
	private static let placeService = PlaceService(context: container.mainContext)
	private static let textDetectionService = TextDetectionService()
	private static let incomeService = IncomeService(context: container.mainContext)
	private static let notificationService = NotificationService()
	private static let userDataService = UserDataService(searchService: searchService)
	
	static func provideModelContainer() -> ModelContainer {
		container
	}
	
	static func provideSearchService() -> SearchService {
		searchService
	}
	
	static func provideCardsService() -> CardsService {
		cardsService
	}
	
	static func provideCategoryService() -> CategoryService {
		categoryService
	}
	
	static func providePlaceService() -> PlaceService {
		placeService
	}
	
	static func provideTextDetectionService() -> TextDetectionService {
		textDetectionService
	}
	
	static func provideIncomeService() -> IncomeService {
		incomeService
	}
	
	static func provideNotificationService() -> NotificationService {
		notificationService
	}
	
	static func provideUserDataService() -> UserDataService {
		userDataService
	}
}
