//
//  CardsListScreen.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import CommonInput
import DesignSystem
import Domain
import SwiftData
import SwiftUI

struct CardsListScreen: View {
	let onCardSelected: (Card) -> Void
	
	@State private var searchText = ""
	@State private var isAddCardSheetPresented = false
	@State private var cardToBeRenamed: Card?
	@Query private var cards: [Card]
	@Environment(\.modelContext) private var context
	
	var body: some View {
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
						context.insert(card)
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
		if cards.isEmpty {
			if searchText.isEmpty {
				ContentUnavailableView("Нет сохраненных кэшбеков", systemImage: "rublesign.circle")
			} else {
				ContentUnavailableView("Такой кэшбек не найден", systemImage: "magnifyingglass")
			}
		} else {
			ScrollView {
				LazyVStack(spacing: 16) {
					ForEach(cards) { card in
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
										context.delete(card)
										for cashback in card.cashback {
											context.delete(cashback)
										}
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
				.animation(.default, value: cards)
				.padding(.horizontal, 12)
			}
			.scrollDismissesKeyboard(.interactively)
			.background(Color.cmScreenBackground)
		}
	}
}
