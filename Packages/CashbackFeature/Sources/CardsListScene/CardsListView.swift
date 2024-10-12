//
//  CardsListView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import AppIntents
import CommonInputSheet
import DesignSystem
import Domain
import SearchService
import SwiftData
import SwiftUI

public struct CardsListView: View {
	private let addCardIntent: any AppIntent
	private let checkCategoryCardIntent: any AppIntent
	private let onCardSelected: (Card) -> Void
	
	@State private var searchText = ""
	@State private var isAddCardSheetPresented = false
	@State private var cardToBeRenamed: Card?
	@Query(
		sort: [SortDescriptor<Card>(\.name, order: .forward)],
		animation: .default
	) private var cards: [Card]
	@Environment(\.modelContext) private var context
	@Environment(\.searchService) var searchService
	
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
			.sheet(item: $cardToBeRenamed) { card in
				renameCardSheet(card)
			}
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
				IntentTipView(intent: checkCategoryCardIntent, text: "Чтобы быстро найти карту")
				
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
	
	@MainActor
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
		.sensoryFeedback(.impact, trigger: isAddCardSheetPresented)
	}
	
	private func renameCardSheet(_ card: Card) -> some View {
		NavigationView {
			CommonInputView("Название карты", text: card.name) { cardName in
				onCardNameChanged(cardName, card: card)
			}
			.navigationTitle("Переименовать карту")
			.navigationBarTitleDisplayMode(.inline)
		}
		.presentationDetents([.medium])
		.presentationBackground(.regularMaterial)
	}
	
	private func cardView(_ card: Card) -> some View {
		Button {
			onCardSelected(card)
		} label: {
			CardItemView(card: card)
				.contextMenu {
					Text(card.name)
					
					renameCardButton(card)
					
					deleteCardButton(card)
				} preview: {
					CashbackListView(cashback: card.cashback)
				}
		}
		.buttonStyle(.plain)
	}
	
	private func renameCardButton(_ card: Card) -> some View {
		Button {
			cardToBeRenamed = card
		} label: {
			Text("Переименовать карту")
		}
		.sensoryFeedback(.impact, trigger: cardToBeRenamed)
	}
	
	private func deleteCardButton(_ card: Card) -> some View {
		Button(role: .destructive) {
			delete(card: card)
		} label: {
			Text("Удалить карту")
		}
	}
	
	private func onCardNameChanged(_ cardName: String, card: Card) {
		card.name = cardName
		context.insert(card)
		searchService?.index(card: card)
		cardToBeRenamed = nil
	}
		
	@MainActor
	private func create(cardName: String) {
		let card = Card(name: cardName)
		context.insert(card)
		searchService?.index(card: card)
		isAddCardSheetPresented = false
		onCardSelected(card)
	}
	
	private func delete(card: Card) {
		searchService?.deindex(card: card)
		context.delete(card)
	}
}
