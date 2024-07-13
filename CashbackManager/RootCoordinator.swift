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
	
	@State private var navigationStack: [Navigation] = []
	
	init(serviceContainer: ServiceContainer) {
		self.serviceContainer = serviceContainer
	}
	
    var body: some View {
		NavigationStack(path: $navigationStack) {
			BanksListAssembly.assemble(
				banksCoordinator: self,
				cashbackService: serviceContainer.cashbackService
			)
			.navigationDestination(for: Navigation.self, destination: navigate(to:))
		}
    }
	
	@MainActor @ViewBuilder
	private func navigate(to destination: Navigation) -> some View {
		switch destination {
		case .selectBank(let banks):
			SelectBankAssembly.assemble(coordinator: self, cashbackService: serviceContainer.cashbackService)
		case .selectCard(let bank):
			SelectCardAssembly.assemble(bank: bank, coordinator: self, cashbackService: serviceContainer.cashbackService)
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

extension RootCoordinator: BanksListCoordinator {
	func onAddCashbackTap(banks: [Bank]) {
		navigationStack.append(.selectBank(banks))
	}
	
	func onCardSelected(card: Card) {
		navigationStack.append(.cardDetail(card))
	}
	
	func onBankSelected(bank: Bank) {
		navigationStack.append(.selectCard(bank))
	}
}

extension RootCoordinator: SelectBankCoordinator {
	func navigateToBankDetail(bank: Bank) {
		navigationStack.append(.selectCard(bank))
	}
}

extension RootCoordinator: SelectCardCoordinator {	
	func navigateToCardDetail(card: Card) {
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
