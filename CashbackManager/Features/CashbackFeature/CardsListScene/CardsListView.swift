//
//  CardsListView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import AppIntents
import SwiftData
import SwiftUI

struct CardsListView: View {
	private let addCardIntent: any AppIntent
	private let checkCategoryCardIntent: any AppIntent
	private let onCardSelected: (Card) -> Void
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@State private var searchText = ""
	@State private var isAddCardSheetPresented = false
	@State private var selectedCategory: Category?
	
	@Query(
		filter: #Predicate<Card> { !$0.isArchived },
		sort: [SortDescriptor<Card>(\.isFavorite, order: .reverse),
			SortDescriptor<Card>(\.name, order: .forward)],
		animation: .default
	) private var cards: [Card]
	
	@Query(
		filter: #Predicate<Category> { $0.priority > 0 },
		sort: [SortDescriptor<Category>(\.priority, order: .reverse)]
	)
	private var categories: [Category]
	
	@Environment(\.cardsService) private var cardsService
		
	private var filteredCards: [Card] {
		cards.filter { card in
			if searchText.isEmpty {
				if let selectedCategory  {
					card.cashbackDescription.localizedStandardContains(selectedCategory.name)
				} else {
					true
				}
			} else {
				card.cashbackDescription.localizedStandardContains(searchText)
				|| card.cashback.compactMap(\.category.synonyms).contains {
						$0.localizedStandardContains(searchText)
					}
			}
		}
	}
	
	private var popularCategories: [Category] {
		Array(categories.prefix(5))
	}
	
	init(
		addCardIntent: any AppIntent,
		checkCategoryCardIntent: any AppIntent,
		onCardSelected: @escaping (Card) -> Void
	) {
		self.addCardIntent = addCardIntent
		self.checkCategoryCardIntent = checkCategoryCardIntent
		self.onCardSelected = onCardSelected
	}
	
	var body: some View {
		contentView
			.navigationTitle("Мои карты")
			.if(!cards.isEmpty) {
				$0.searchable(
					text: $searchText,
					placement: .navigationBarDrawer(displayMode: .always),
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
			.onChange(of: searchText) {
				if !searchText.isEmpty {
					selectedCategory = nil
				}
			}
			.onChange(of: selectedCategory) {
				if selectedCategory != nil {
					searchText = ""
				}
			}
	}
	
	@ViewBuilder
	private var contentView: some View {
		VStack {
			if !cards.isEmpty {
				FilterView(popularCategories: popularCategories, selectedCategory: $selectedCategory)
			}
			
			if filteredCards.isEmpty {
				if searchText.isEmpty && selectedCategory == nil {
					ContentUnavailableView("Добавьте первую карту, чтобы начать управлять кэшбэком", systemImage: Constants.SFSymbols.cashback)
				} else {
					ContentUnavailableView("Такой кэшбэк не найден\nПопробуйте изменить запрос", systemImage: Constants.SFSymbols.search)
				}
			} else {
				ScrollView {
					LazyVStack {
						Spacer()
							.frame(height: 16)
						
						if areSiriTipsVisible, !searchText.isEmpty {
							IntentTipView(intent: checkCategoryCardIntent, text: "Чтобы быстро найти карту")
						}
						
						ForEach(filteredCards) { card in
							CardItemView(card: card, searchQuery: searchText)
								.onTapGesture {
									onCardSelected(card)
								}
						}
						
						Spacer()
							.frame(height: 16)
					}
				}
				.scrollDismissesKeyboard(.interactively)
				.scrollIndicators(.hidden)
				.padding(.horizontal, 16)
			}
		}
	}
	
	private var addCardSheet: some View {
		NavigationView {
			AddCardView("Название карты", intent: addCardIntent, hint: "В следующий раз, чтобы добавить карту") { cardName, color in
				create(cardName: cardName, color: color)
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
		
	private func create(cardName: String, color: Color) {
		guard let cardsService else { return }
		
		let card = cardsService.createCard(name: cardName, color: color.toHex())
		isAddCardSheetPresented = false
		onCardSelected(card)
		hapticFeedback(.light)
	}
}
