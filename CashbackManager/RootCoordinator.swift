//
//  RootCoordinator.swift
//  CashbackManager
//
//  Created by Alexander on 10.06.2024.
//

import Domain
import SwiftUI

struct RootCoordinator: View {
	private let serviceContainer: ServiceContainer
	private let urlParser: WidgetURLParser
	
	@State private var navigationStack: [Navigation] = []
	
	init(serviceContainer: ServiceContainer, urlParser: WidgetURLParser) {
		self.serviceContainer = serviceContainer
		self.urlParser = urlParser
	}
	
    var body: some View {
		NavigationStack(path: $navigationStack) {
			CardsListAssembly.assemble(
				banksCoordinator: self,
				cashbackService: serviceContainer.cashbackService
			)
			.navigationDestination(for: Navigation.self, destination: navigate(to:))
		}
		.onOpenURL { url in
			if let path = urlParser.parse(url: url) {
				navigationStack = path
			}
		}
    }
	
	@MainActor @ViewBuilder
	private func navigate(to destination: Navigation) -> some View {
		switch destination {
		case .cardDetail(let card):
			CashbackAssembly.assemble(
				card: card,
				coordinator: self,
				cashbackService: serviceContainer.cashbackService
			)
		case .addCashback(let card):
			AddCashbackAssembly.assemble(card: card, coordinator: self, categoryService: serviceContainer.categoryService, cashbackService: serviceContainer.cashbackService)
		}
	}
}

extension RootCoordinator: CardsListCoordinator {
	func onCardSelected(card: Card) {
		navigationStack.append(.cardDetail(card))
	}
}

extension RootCoordinator: CashbackCoordinator {
	func navigateToAddCashback(card: Card) {
		navigationStack.append(.addCashback(card))
	}
}

extension RootCoordinator: AddCashbackCoordinator {
	func navigateBack() {
		_ = navigationStack.popLast()
	}
}
