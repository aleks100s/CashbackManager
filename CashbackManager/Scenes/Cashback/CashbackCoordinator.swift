//
//  CashbackCoordinator.swift
//  CashbackApp
//
//  Created by Alexander on 25.06.2024.
//

protocol CashbackCoordinator {
	func navigateToAddCashback(card: Card)
}

struct FakeCashbackCoordinator: CashbackCoordinator {
	func navigateToAddCashback(card: Card) {}
}
