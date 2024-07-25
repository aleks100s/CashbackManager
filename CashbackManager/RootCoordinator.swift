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
			CardsListScreen { card in
				navigationStack.append(.cardDetail(card))
			}
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
			CardDetailScreen(card: card) {
				navigationStack.append(.addCashback(card))
			}
		case .addCashback(let card):
			AddCashbackAssembly.assemble(card: card, coordinator: self, categoryService: serviceContainer.categoryService, cashbackService: serviceContainer.cashbackService)
		}
	}
}

extension RootCoordinator: AddCashbackCoordinator {
	func navigateBack() {
		_ = navigationStack.popLast()
	}
}
