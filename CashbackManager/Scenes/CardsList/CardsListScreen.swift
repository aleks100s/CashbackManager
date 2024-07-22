//
//  CardsListScreen.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import CommonInput
import DesignSystem
import SwiftUI

struct CardsListScreen: View {
	@State private var store: CardsListStore
		
	init(store: CardsListStore) {
		self.store = store
	}
	
	var body: some View {
		contentView
			.navigationTitle("Мои кэшбеки")
			.onAppear {
				store.send(.onAppear)
			}
			.if(!store.allCards.isEmpty) {
				$0.searchable(
					text: Binding(get: { store.searchText }, set: { store.send(.searchTextChanged($0)) }),
					placement: .navigationBarDrawer(displayMode: .automatic),
					prompt: "Категория кэшбека"
				)
			}
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					Button("Добавить карту") {
						store.send(.onAddCardTapped)
					}
				}
			}
			.sheet(isPresented: Binding(get: { store.isAddCardSheetPresented }, set: { _, _ in store.send(.dismissAddCard)})) {
				NavigationView {
					CommonInputView("Название карты") { cardName in
						store.send(.saveCard(cardName))
					}
					.navigationTitle("Добавить новую карту")
					.navigationBarTitleDisplayMode(.inline)
				}
				.presentationDetents([.medium])
				.presentationBackground(.regularMaterial)
			}
			.sheet(item: Binding(get: { store.cardToBeRenamed }, set: { _ in store.send(.dismissCardRename) })) { card in
				NavigationView {
					CommonInputView("Название карты", text: card.name) { cardName in
						store.send(.cardRenamed(cardName))
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
		if store.state.filteredCards.isEmpty {
			if store.searchText.isEmpty {
				ContentUnavailableView("Нет сохраненных кэшбеков", systemImage: "rublesign.circle")
			} else {
				ContentUnavailableView("Такой кэшбек не найден", systemImage: "magnifyingglass")
			}
		} else {
			ScrollView {
				LazyVStack(spacing: 16) {
					ForEach(store.filteredCards) { card in
						Button {
							store.send(.onCardSelected(card))
						} label: {
							CardView(card: card)
								.contextMenu {
									Text(card.name)
									Button {
										store.send(.onCardRenameTapped(card))
									} label: {
										Text("Переименовать карту")
									}
									Button(role: .destructive) {
										store.send(.onCardDeleted(card))
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
}
