//
//  CardsListView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import AppIntents
import CardsService
import CommonInputSheet
import DesignSystem
import Domain
import Shared
import SwiftData
import SwiftUI

public struct CardsListView: View {
	private let addCardIntent: any AppIntent
	private let checkCategoryCardIntent: any AppIntent
	private let onCardSelected: (Card) -> Void
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@State private var searchText = ""
	@State private var isAddCardSheetPresented = false
	@State private var toast: Toast?
	
	@Query(
		filter: #Predicate<Card> { !$0.isArchived },
		sort: [SortDescriptor<Card>(\.name, order: .forward)],
		animation: .default
	) private var cards: [Card]
	@Environment(\.cardsService) private var cardsService
	
	private var filteredCards: [Card] {
		cards.filter {
			searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText) || $0.cashbackDescription.localizedStandardContains(searchText) ||
				$0.cashback.compactMap(\.category.synonyms).contains { $0.localizedStandardContains(searchText) }
		}
	}
	
	public init(
		addCardIntent: any AppIntent,
		checkCategoryCardIntent: any AppIntent,
		onCardSelected: @escaping (Card) -> Void
	) {
		self.addCardIntent = addCardIntent
		self.checkCategoryCardIntent = checkCategoryCardIntent
		self.onCardSelected = onCardSelected
	}
	
	public var body: some View {
		contentView
			.navigationTitle("Мои карты")
			.if(!cards.isEmpty) {
				$0.searchable(
					text: $searchText,
					placement: .navigationBarDrawer(displayMode: .automatic),
					prompt: "Категория кэшбэка"
				)
			}
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					addCardButton
				}
			}
			.sheet(isPresented: $isAddCardSheetPresented) {
				addCardSheet
			}
			.toast(item: $toast)
	}
	
	@ViewBuilder
	private var contentView: some View {
		if filteredCards.isEmpty {
			if searchText.isEmpty {
				ContentUnavailableView("Нет сохраненных карт", systemImage: "creditcard")
			} else {
				ContentUnavailableView("Такой кэшбэк не найден", systemImage: "magnifyingglass")
			}
		} else {
			List {
				if areSiriTipsVisible {
					IntentTipView(intent: checkCategoryCardIntent, text: "Чтобы быстро найти карту")
				}
				
				ForEach(filteredCards) { card in
					Section(card.name) {
						cardView(card)
					}
				}
			}
			.listSectionSpacing(8)
			.scrollDismissesKeyboard(.interactively)
		}
	}
	
	private var addCardSheet: some View {
		NavigationView {
			CommonInputView("Название карты", intent: addCardIntent, hint: "В следующий раз, чтобы добавить карту") { cardName in
				create(cardName: cardName)
			}
			.navigationTitle("Добавить новую карту")
			.navigationBarTitleDisplayMode(.inline)
		}
		.presentationDetents([.medium])
		.presentationBackground(Color.cmScreenBackground)
	}
	
	private var addCardButton: some View {
		Button("Добавить карту") {
			isAddCardSheetPresented = true
		}
	}
	
	private func cardView(_ card: Card) -> some View {
		Button {
			onCardSelected(card)
		} label: {
			CardItemView(card: card)
				.contextMenu {
					Text(card.name)
				} preview: {
					CashbackListView(cashback: card.cashback)
				}
		}
		.buttonStyle(.plain)
	}
		
	private func create(cardName: String) {
		guard let cardsService else { return }
		let card = cardsService.createCard(name: cardName)
		isAddCardSheetPresented = false
		onCardSelected(card)
		hapticFeedback(.light)
	}
}
