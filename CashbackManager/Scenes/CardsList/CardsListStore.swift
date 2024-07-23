//
//  CardsListStore.swift
//  CashbackManager
//
//  Created by Alexander on 20.06.2024.
//

import Domain
import Store

typealias CardsListStore = Store<CardsListState, CardsListEffectHandler>

struct CardsListState {
	var allCards = [Card]()
	var filteredCards = [Card]()
	var isAddCardSheetPresented = false
	var cardToBeRenamed: Card?
	var searchText = ""
}

extension CardsListState: StoreState {
	enum Input {
		case onAppear
		case onAddCardTapped
		case dismissAddCard
		case onCardSelected(Card)
		case onCardDeleted(Card)
		case onCardRenameTapped(Card)
		case dismissCardRename
		case cardRenamed(String)
		case searchTextChanged(String)
		case saveCard(String)
	}
	
	enum Effect {
		case fetchCards
		case navigateToCardDetail(Card)
		case deleteCard(Card)
		case updateCard(Card)
		case saveCard(Card)
	}
	
	enum Feedback {
		case cardsFetched([Card])
		case cardDeleted
		case cardRenamed
		case cardSaved
	}
	
	static func reduce(state: inout CardsListState, with message: Message<Input, Feedback>) -> Effect? {
		switch message {
		case .input(.onAppear):
			return .fetchCards
		case .input(.onAddCardTapped):
			state.isAddCardSheetPresented = true
		case .input(.dismissAddCard):
			state.isAddCardSheetPresented = false
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
		case .input(.searchTextChanged(let text)):
			state.searchText = text
			let text = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
			guard !text.isEmpty else {
				state.filteredCards = state.allCards
				break
			}
			
			let filteredCards = state.allCards.filter { card in
				card.cashbackDescription.lowercased().contains(text)
			}
			state.filteredCards = filteredCards
		case .input(.saveCard(let cardName)):
			let card = Card(name: cardName, cashback: [])
			state.isAddCardSheetPresented = false
			return .saveCard(card)
		case .feedback(.cardsFetched(let cards)):
			state.allCards = cards
			state.filteredCards = cards
		case .feedback(.cardDeleted):
			return .fetchCards
		case .feedback(.cardRenamed):
			return .fetchCards
		case .feedback(.cardSaved):
			return .fetchCards
		}
		return nil
	}
}

final class CardsListEffectHandler: EffectHandler {
	typealias S = CardsListState
	
	private let coordinator: CardsListCoordinator
	private let cashbackService: ICashbackService
	
	init(coordinator: CardsListCoordinator, cashbackService: ICashbackService) {
		self.coordinator = coordinator
		self.cashbackService = cashbackService
	}
	
	func handle(effect: CardsListState.Effect) async -> CardsListState.Feedback? {
		switch effect {
		case .fetchCards:
			let cards = cashbackService.getCards()
			return .cardsFetched(cards)
		case .navigateToCardDetail(let card):
			coordinator.onCardSelected(card: card)
		case .deleteCard(let card):
			cashbackService.delete(card: card)
			return .cardDeleted
		case .updateCard(let card):
			cashbackService.update(card: card)
			return .cardRenamed
		case .saveCard(let card):
			cashbackService.save(card: card)
			return .cardSaved
		}
		
		return nil
	}
}
