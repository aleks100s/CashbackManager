//
//  BanksListCoordinator.swift
//  CashbackManager
//
//  Created by Alexander on 20.06.2024.
//

import Domain

protocol BanksListCoordinator {
	func onAddCashbackTap(banks: [Bank])
	func onCardSelected(card: Card)
}

struct FakeBanksListCoordinator: BanksListCoordinator {
	func onAddCashbackTap(banks: [Bank]) {}
	func onCardSelected(card: Card) {}
}
