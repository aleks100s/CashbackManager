//
//  CashbackStore.swift
//  CashbackManager
//
//  Created by Alexander on 25.06.2024.
//

import Domain
import Foundation
import Store
import WidgetKit

typealias CashbackStore = Store<CashbackState, CashbackEffectHandler>

struct CashbackState {
	var card: Card
}

extension CashbackState: StoreState {
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
	
	static func reduce(state: inout CashbackState, with message: Message<Input, Feedback>) -> Effect? {
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
	typealias S = CashbackState
		
	private let coordinator: CashbackCoordinator
	private let cashbackService: ICashbackService
	
	init(coordinator: CashbackCoordinator, cashbackService: ICashbackService) {
		self.coordinator = coordinator
		self.cashbackService = cashbackService
	}
	
	func handle(effect: CashbackState.Effect) async -> CashbackState.Feedback? {
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
