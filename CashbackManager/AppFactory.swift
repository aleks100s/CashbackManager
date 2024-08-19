//
//  AppFactory.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import CategoryService
import Domain
import PlaceService
import SearchService
import SwiftData

enum AppFactory {
	private static var container = try! ModelContainer(for: Card.self, Cashback.self, Domain.Category.self, Place.self)
	
	static func provideModelContainer() -> ModelContainer {
		container
	}
	
	static func provideSearchService() -> SearchService {
		SearchService()
	}
	
	@MainActor 
	static func provideCategoryService() -> CategoryService {
		CategoryService(context: container.mainContext)
	}
	
	@MainActor
	static func providePlaceService() -> PlaceService {
		PlaceService(context: container.mainContext)
	}
}
