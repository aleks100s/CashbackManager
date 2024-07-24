//
//  CardDetailStore.swift
//  CashbackManager
//
//  Created by Alexander on 25.06.2024.
//

import Domain
import Foundation
import Store
import WidgetKit

typealias CardDetailStore = Store<CardDetailState, CashbackEffectHandler>

struct CardDetailState {
	var card: Card
}

extension CardDetailState: StoreState {
	enum Input {
		case viewDidAppear
		case onAddCashbackTap
		case onDeleteCashbackTap(IndexSet)
		case onDeleteCashbackMenuTap(Cashback)
	}
	
	enum Effect {
		case navigateToAddCashback(Card)
		case updateCard(Card)
		case fetchCard(id: UUID)
	}
	
	enum Feedback {
		case cardFetched(Card?)
	}
	
	static func reduce(state: inout CardDetailState, with message: Message<Input, Feedback>) -> Effect? {
		switch message {
		case .input(.viewDidAppear):
			return .fetchCard(id: state.card.id)
		case .input(.onAddCashbackTap):
			return .navigateToAddCashback(state.card)
		case .input(.onDeleteCashbackTap(let indexSet)):
			state.card.cashback.remove(atOffsets: indexSet)
			return .updateCard(state.card)
		case .input(.onDeleteCashbackMenuTap(let cashback)):
			state.card.cashback.removeAll(where: { $0 == cashback })
			return .updateCard(state.card)
		case .feedback(.cardFetched(let card)):
			if let card {
				state.card = card
			}
		}
		return nil
	}
}

typealias CashbackDelegate = (Card) -> Void

final class CashbackEffectHandler: EffectHandler {
	typealias S = CardDetailState
		
	private let coordinator: CardDetailCoordinator
	private let cashbackService: ICashbackService
	
	init(coordinator: CardDetailCoordinator, cashbackService: ICashbackService) {
		self.coordinator = coordinator
		self.cashbackService = cashbackService
	}
	
	func handle(effect: CardDetailState.Effect) async -> CardDetailState.Feedback? {
		switch effect {
		case .navigateToAddCashback(let card):
			coordinator.navigateToAddCashback(card: card)
		case .fetchCard(let id):
			if let card = cashbackService.getCard(by: id) {
				cashbackService.save(currentCard: card)
				WidgetCenter.shared.reloadAllTimelines()
				return .cardFetched(card)
			}
		case .updateCard(let card):
			cashbackService.update(card: card)
		}
		return nil
	}
}
