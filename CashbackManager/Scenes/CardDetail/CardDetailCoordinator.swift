//
//  CardDetailCoordinator.swift
//  CashbackManager
//
//  Created by Alexander on 25.06.2024.
//

import Domain

protocol CardDetailCoordinator {
	func navigateToAddCashback(card: Card)
}

struct FakeCashbackCoordinator: CardDetailCoordinator {
	func navigateToAddCashback(card: Card) {}
}
