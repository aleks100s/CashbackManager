//
//  CashbackApplication.swift
//  CashbackManager
//
//  Created by Alexander on 10.06.2024.
//

import AppIntents
import CashbackFeature
import Domain
import PlaceFeature
import SearchService
import Shared
import SwiftData
import SwiftUI

@main
@MainActor
struct CashbackApplication: App {
	private let container = AppFactory.provideModelContainer()
	private let searchService = AppFactory.provideSearchService()
	private let categoryService = AppFactory.provideCategoryService()
	private let placeService = AppFactory.providePlaceService()
	private let cardsService = AppFactory.provideCardsService()
	
	init() {
		let searchService = self.searchService
		let categoryService = self.categoryService
		let placeService = self.placeService
		let cardsService = self.cardsService
		AppDependencyManager.shared.add(dependency: searchService)
		AppDependencyManager.shared.add(dependency: categoryService)
		AppDependencyManager.shared.add(dependency: placeService)
		AppDependencyManager.shared.add(dependency: cardsService)
	}

    var body: some Scene {
        WindowGroup {
			TabView {
				CashbackFeatureAssembly.assemble(container: container)
					.tabItem {
						Label("Кэшбек", systemImage: Constants.SFSymbols.rubleSign)
					}
				
				PlaceFeatureAssembly.assemble()
					.tabItem {
						Label("Места", systemImage: Constants.SFSymbols.mapPin)
					}
			}
			
        }
		.modelContainer(container)
		.environment(\.searchService, searchService)
		.environment(\.categoryService, categoryService)
		.environment(\.placeService, placeService)
    }
}
