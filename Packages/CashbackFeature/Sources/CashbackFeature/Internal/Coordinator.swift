//
//  Coordinator.swift
//  CashbackManager
//
//  Created by Alexander on 10.06.2024.
//

import AddCashbackScene
import AppIntents
import CardDetailScene
import CardsListScene
import Domain
import Shared
import SwiftData
import SwiftUI

struct Coordinator: View {
	let addCardIntent: any AppIntent
	let checkCategoryCardIntent: any AppIntent
	let cardCashbackIntent: any AppIntent
	let addCategoryIntent: any AppIntent
	let addCashbackIntent: any AppIntent
	
	@State private var navigationStack: [Navigation] = []
	@State private var cardToAddCashback: Card?
	
	@AppStorage(Constants.StorageKey.firstLaunch) private var isFirstLaunch = true

	@Environment(\.modelContext) private var context
	@Environment(\.widgetURLParser) private var urlParser
	
	@Query private var categories: [Domain.Category]
	
    var body: some View {
		NavigationStack(path: $navigationStack) {
			CardsListView(addCardIntent: addCardIntent, checkCategoryCardIntent: checkCategoryCardIntent) { card in
				navigationStack.append(.cardDetail(card))
			}
			.navigationDestination(for: Navigation.self, destination: navigate(to:))
		}
		.sheet(item: $cardToAddCashback) { card in
			NavigationView {
				AddCashbackView(card: card, addCategoryIntent: addCategoryIntent, addCashbackIntent: addCashbackIntent)
			}
			.presentationDetents([.medium, .large])
		}
		.onOpenURL { url in
			if let path = urlParser?.parse(url: url) {
				navigationStack = path
			}
		}
		.onAppear {
			if isFirstLaunch {
				prepopulateDatabase()
			} else {
				actualizeDatabase()
			}
			isFirstLaunch = false
		}
    }
	
	@MainActor @ViewBuilder
	private func navigate(to destination: Navigation) -> some View {
		switch destination {
		case .cardDetail(let card):
			CardDetailView(card: card, cardCashbackIntent: cardCashbackIntent) {
				cardToAddCashback = card
			}
		}
	}
	
	private func prepopulateDatabase() {
		let categories = PredefinedCategory.allCases.map(\.asCategory)
		for category in categories {
			context.insert(category)
		}
	}
	
	private func actualizeDatabase() {
		let predefinedCategories = PredefinedCategory.allCases.map(\.asCategory)
		for predefined in predefinedCategories {
			if let category = categories.first(where: { $0.name == predefined.name }) {
				category.synonyms = predefined.synonyms
			} else {
				context.insert(predefined)
			}
		}
	}
}
