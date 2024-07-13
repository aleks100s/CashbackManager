//
//  CashbackCoordinator.swift
//  CashbackManager
//
//  Created by Alexander on 25.06.2024.
//

import Domain

protocol CashbackCoordinator {
	func navigateToAddCashback(card: Card)
}

struct FakeCashbackCoordinator: CashbackCoordinator {
	func navigateToAddCashback(card: Card) {}
}
