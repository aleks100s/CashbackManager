//
//  BanksListScreen.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import CommonInput
import SwiftUI

struct BanksListScreen: View {
	@State private var store: BanksListStore
		
	init(store: BanksListStore) {
		self.store = store
	}
	
	var body: some View {
		contentView
			.navigationTitle("Мои кэшбеки")
			.onAppear {
				store.send(.onAppear)
			}
			.if(!store.allBanks.isEmpty) {
				$0.searchable(
					text: Binding(get: { store.searchText }, set: { store.send(.searchTextChanged($0)) }),
					placement: .navigationBarDrawer(displayMode: .automatic),
					prompt: "Категория кэшбека"
				)
			}
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					Button("Добавить кэшбек") {
						store.send(.onAddCashbackTap)
					}
				}
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
		if store.state.filteredBanks.isEmpty {
			if store.searchText.isEmpty {
				ContentUnavailableView("Нет сохраненных кэшбеков", systemImage: "rublesign.circle")
			} else {
				ContentUnavailableView("Такой кэшбек не найден", systemImage: "magnifyingglass")
			}
		} else {
			ScrollView {
				LazyVStack(spacing: .zero) {
					ForEach(store.state.filteredBanks) { bank in
						BankView(bank: bank) { card, action in
							switch action {
							case .select:
								store.send(.onCardSelected(card))
							case .rename:
								store.send(.onCardRenameTapped(card))
							case .delete:
								store.send(.onCardDeleted(card))
							}
						}
					}
				}
			}
			.scrollDismissesKeyboard(.interactively)
			.background(Color.cmScreenBackground)
		}
	}
}
