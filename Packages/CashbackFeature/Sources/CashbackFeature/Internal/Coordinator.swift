//
//  Coordinator.swift
//  CashbackManager
//
//  Created by Alexander on 10.06.2024.
//

import AddCashbackScene
import CardDetailScene
import CardsListScene
import Domain
import SwiftUI

struct Coordinator: View {
	let urlParser: WidgetURLParser
	
	@State private var navigationStack: [Navigation] = []
	@State private var cardToAddCashback: Card?
	
	@AppStorage("IsFirstLaunch") private var isFirstLaunch = true

	@Environment(\.modelContext) private var context
	
    var body: some View {
		NavigationStack(path: $navigationStack) {
			CardsListView { card in
				navigationStack.append(.cardDetail(card))
			}
			.navigationDestination(for: Navigation.self, destination: navigate(to:))
		}
		.sheet(item: $cardToAddCashback) { card in
			NavigationView {
				AddCashbackView(card: card)
			}
		}
		.onOpenURL { url in
			if let path = urlParser.parse(url: url) {
				navigationStack = path
			}
		}
		.onAppear {
			if isFirstLaunch {
				prepopulateDatabase()
			}
			isFirstLaunch = false
		}
    }
	
	@MainActor @ViewBuilder
	private func navigate(to destination: Navigation) -> some View {
		switch destination {
		case .cardDetail(let card):
			CardDetailView(card: card) {
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
}
