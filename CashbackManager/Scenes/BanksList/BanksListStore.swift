//
//  BanksListStore.swift
//  CashbackManager
//
//  Created by Alexander on 20.06.2024.
//

typealias BanksListStore = Store<BanksListState, BanksListEffectHandler>

struct BanksListState {
	var banks = [Bank]()
	var cardToBeRenamed: Card?
}

extension BanksListState: StoreState {
	enum Input {
		case onAppear
		case onAddCashbackTap
		case onCardSelected(Card)
		case onCardDeleted(Card)
		case onCardRenameTapped(Card)
		case dismissCardRename
		case cardRenamed(String)
	}
	
	enum Effect {
		case fetchBanks
		case navigateToBankSelection([Bank])
		case navigateToCardDetail(Card)
		case deleteCard(Card)
		case updateCard(Card)
	}
	
	enum Feedback {
		case banksFetched([Bank])
		case cardDeleted
		case cardRenamed
	}
	
	static func reduce(state: inout BanksListState, with message: Message<Input, Feedback>) -> Effect? {
		switch message {
		case .input(.onAppear):
			return .fetchBanks
		case .input(.onAddCashbackTap):
			return .navigateToBankSelection(state.banks)
		case .input(.onCardSelected(let card)):
			return .navigateToCardDetail(card)
		case .input(.onCardDeleted(let card)):
			return .deleteCard(card)
		case .input(.onCardRenameTapped(let card)):
			state.cardToBeRenamed = card
		case .input(.dismissCardRename):
			state.cardToBeRenamed = nil
		case .input(.cardRenamed(let name)):
			if var card = state.cardToBeRenamed {
				card.name = name
				state.cardToBeRenamed = nil
				return .updateCard(card)
			}
		case .feedback(.banksFetched(let banks)):
			state.banks = banks
		case .feedback(.cardDeleted):
			return .fetchBanks
		case .feedback(.cardRenamed):
			return .fetchBanks
		}
		return nil
	}
}

final class BanksListEffectHandler: EffectHandler {
	typealias S = BanksListState
	
	private let coordinator: BanksListCoordinator
	private let cashbackService: ICashbackService
	
	init(coordinator: BanksListCoordinator, cashbackService: ICashbackService) {
		self.coordinator = coordinator
		self.cashbackService = cashbackService
	}
	
	func handle(effect: BanksListState.Effect) async -> BanksListState.Feedback? {
		switch effect {
		case .fetchBanks:
			let banks = cashbackService.getBanks()
			return .banksFetched(banks)
		case .navigateToBankSelection(let banks):
			coordinator.onAddCashbackTap(banks: banks)
		case .navigateToCardDetail(let card):
			coordinator.onCardSelected(card: card)
		case .deleteCard(let card):
			cashbackService.delete(card: card)
			return .cardDeleted
		case .updateCard(let card):
			cashbackService.update(card: card)
			return .cardRenamed
		}
		
		return nil
	}
}
