//
//  CardsListCoordinator.swift
//  CashbackManager
//
//  Created by Alexander on 20.06.2024.
//

import Domain

protocol CardsListCoordinator {
	func onCardSelected(card: Card)
}

struct FakeCardsListCoordinator: CardsListCoordinator {
	func onCardSelected(card: Card) {}
}
