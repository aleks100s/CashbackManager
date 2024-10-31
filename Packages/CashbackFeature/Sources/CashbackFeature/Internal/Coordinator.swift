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
		.onReceive(NotificationCenter.default.publisher(for: Constants.resetAppNavigationNotification)) { _ in
			navigationStack = []
		}
    }
	
	@ViewBuilder
	private func navigate(to destination: Navigation) -> some View {
		switch destination {
		case .cardDetail(let card):
			CardDetailView(card: card, cardCashbackIntent: cardCashbackIntent) {
				cardToAddCashback = card
			}
		}
	}
}
