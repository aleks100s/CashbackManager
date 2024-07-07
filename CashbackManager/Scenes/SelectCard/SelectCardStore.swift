//
//  SelectCardStore.swift
//  CashbackManager
//
//  Created by Alexander on 27.06.2024.
//

typealias SelectCardStore = Store<SelectCardState, SelectCardEffectHandler>

struct SelectCardState {
	var bank: Bank
	var isAddCardSheetPresented = false
	var cardToBeRenamed: Card? = nil
}

extension SelectCardState: StoreState {
	enum Input {
		case viewDidAppear
		case onCardSelected(Card)
		case onAddCardTapped
		case dismissAddCard
		case saveCard(String)
		case onCardDeleted(Card)
		case onCardRename(Card)
		case dismissRenameCard
		case cardRenamed(String)
	}
	
	enum Effect {
		case navigateToCardDetail(Card)
		case saveBank(Bank)
		case reloadBank(Bank)
		case deleteCard(Card)
		case updateCard(Card)
	}
	
	enum Feedback {
		case bankReloaded(Bank)
		case cardDeleted
		case cardRenamed
	}
	
	static func reduce(state: inout SelectCardState, with message: Message<Input, Feedback>) -> Effect? {
		switch message {
		case .input(.viewDidAppear):
			return .reloadBank(state.bank)
		case .input(.onCardSelected(let card)):
			return .navigateToCardDetail(card)
		case .input(.onAddCardTapped):
			state.isAddCardSheetPresented = true
		case .input(.dismissAddCard):
			state.isAddCardSheetPresented = false
		case .input(.saveCard(let cardName)):
			let card = Card(name: cardName, cashback: [])
			state.bank.cards.append(card)
			state.isAddCardSheetPresented = false
			return .saveBank(state.bank)
		case .input(.onCardDeleted(let card)):
			return .deleteCard(card)
		case .input(.onCardRename(let card)):
			state.cardToBeRenamed = card
		case .input(.dismissRenameCard):
			state.cardToBeRenamed = nil
		case .input(.cardRenamed(let name)):
			if var card = state.cardToBeRenamed {
				card.name = name
				state.cardToBeRenamed = nil
				return .updateCard(card)
			}
		case .feedback(.cardDeleted):
			return .reloadBank(state.bank)
		case .feedback(.cardRenamed):
			return .reloadBank(state.bank)
		case .feedback(.bankReloaded(let bank)):
			state.bank = bank
		}
		return nil
	}
}

final class SelectCardEffectHandler: EffectHandler {
	typealias S = SelectCardState
	
	private let coordinator: SelectCardCoordinator
	private let cashbackService: ICashbackService
	
	init(coordinator: SelectCardCoordinator, cashbackService: ICashbackService) {
		self.coordinator = coordinator
		self.cashbackService = cashbackService
	}
	
	func handle(effect: SelectCardState.Effect) async -> SelectCardState.Feedback? {
		switch effect {
		case .navigateToCardDetail(let card):
			coordinator.navigateToCardDetail(card: card)
		case .saveBank(let bank):
			cashbackService.update(bank: bank)
		case .reloadBank(let bank):
			guard let bank = cashbackService.getBank(by: bank.id) else {
				return nil
			}
			
			return .bankReloaded(bank)
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


