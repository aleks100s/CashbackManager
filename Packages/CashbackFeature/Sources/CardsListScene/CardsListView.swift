//
//  CardsListView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import CommonInputSheet
import CoreSpotlight
import DesignSystem
import Domain
import SwiftData
import SwiftUI

public struct CardsListView: View {
	private let onCardSelected: (Card) -> Void
	
	@State private var searchText = ""
	@State private var isAddCardSheetPresented = false
	@State private var cardToBeRenamed: Card?
	@Query(animation: .default) private var cards: [Card]
	@Environment(\.modelContext) private var context
	
	private var filteredCards: [Card] {
		cards.filter {
			searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText) || $0.cashbackDescription.localizedStandardContains(searchText)
		}
	}
	
	public init(onCardSelected: @escaping (Card) -> Void) {
		self.onCardSelected = onCardSelected
	}
	
	public var body: some View {
		contentView
			.navigationTitle("Мои кэшбеки")
			.if(!cards.isEmpty) {
				$0.searchable(
					text: $searchText,
					placement: .navigationBarDrawer(displayMode: .automatic),
					prompt: "Категория кэшбека"
				)
			}
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					Button("Добавить карту") {
						isAddCardSheetPresented = true
					}
				}
			}
			.sheet(isPresented: $isAddCardSheetPresented) {
				NavigationView {
					CommonInputView("Название карты") { cardName in
						let card = Card(name: cardName)
						create(card: card)
						isAddCardSheetPresented = false
					}
					.navigationTitle("Добавить новую карту")
					.navigationBarTitleDisplayMode(.inline)
				}
				.presentationDetents([.medium])
				.presentationBackground(.regularMaterial)
			}
			.sheet(item: $cardToBeRenamed) { card in
				NavigationView {
					CommonInputView("Название карты", text: card.name) { cardName in
						card.name = cardName
						context.insert(card)
						cardToBeRenamed = nil
					}
					.navigationTitle("Переименовать карту")
					.navigationBarTitleDisplayMode(.inline)
				}
				.presentationDetents([.medium])
				.presentationBackground(.regularMaterial)
			}
	}
	
	@ViewBuilder
	private var contentView: some View {
		if filteredCards.isEmpty {
			if searchText.isEmpty {
				ContentUnavailableView("Нет сохраненных кэшбеков", systemImage: "rublesign.circle")
			} else {
				ContentUnavailableView("Такой кэшбек не найден", systemImage: "magnifyingglass")
			}
		} else {
			ScrollView {
				LazyVStack(spacing: 16) {
					ForEach(filteredCards) { card in
						Button {
							onCardSelected(card)
						} label: {
							CardView(card: card)
								.contextMenu {
									Text(card.name)
									Button {
										cardToBeRenamed = card
									} label: {
										Text("Переименовать карту")
									}
									Button(role: .destructive) {
										delete(card: card)
									} label: {
										Text("Удалить карту")
									}
								} preview: {
									CashbackListView(cashback: card.cashback)
								}

						}
						.buttonStyle(.plain)
					}
				}
				.padding(.horizontal, 12)
			}
			.scrollDismissesKeyboard(.interactively)
			.background(Color.cmScreenBackground)
		}
	}
	
	@MainActor
	private func create(card: Card) {
		context.insert(card)
		index(card: card)
	}
	
	@MainActor
	private func index(card: Card) {
		let attributeSet = CSSearchableItemAttributeSet(itemContentType: UTType.text.identifier)
		attributeSet.title = card.name
		attributeSet.contentDescription = card.cashbackDescription
		let image = UIImage(named: "AppIcon", in: .main, with: nil)
		attributeSet.thumbnailData = image?.pngData()

		let item = CSSearchableItem(uniqueIdentifier: card.id.uuidString, domainIdentifier: "com.alextos.CashbackManager", attributeSet: attributeSet)
		CSSearchableIndex.default().indexSearchableItems([item]) { error in
			if let error = error {
				print("Indexing error: \(error.localizedDescription)")
			} else {
				print("Search item successfully indexed!")
			}
		}
	}
	
	private func delete(card: Card) {
		deindex(card: card)
		context.delete(card)
		for cashback in card.cashback {
			deindex(cashback: cashback)
			context.delete(cashback)
		}
	}
	
	private func deindex(card: Card) {
		CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [card.id.uuidString]) { error in
			if let error = error {
				print("Deindexing error: \(error.localizedDescription)")
			} else {
				print("Search item successfully removed!")
			}
		}
	}
	
	private func deindex(cashback: Cashback) {
		CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [cashback.id.uuidString]) { error in
			if let error = error {
				print("Deindexing error: \(error.localizedDescription)")
			} else {
				print("Search item successfully removed!")
			}
		}
	}
}
