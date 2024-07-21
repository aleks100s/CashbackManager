//
//  BanksListScreen.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import SwiftUI

struct BanksListScreen: View {
	@State private var store: BanksListStore
		
	init(store: BanksListStore) {
		self.store = store
	}
	
	var body: some View {
		contentView
			.searchable(
				text: Binding(get: { store.searchText }, set: { store.send(.searchTextChanged($0)) }),
				placement: .navigationBarDrawer(displayMode: .always),
				prompt: "Категория кэшбека"
			)
			.navigationTitle("Мои кэшбеки")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Добавить кэшбек", systemImage: "plus") {
						store.send(.onAddCashbackTap)
					}
				}
			}
			.onAppear {
				store.send(.onAppear)
			}
	}
	
	@ViewBuilder
	private var contentView: some View {
		if store.state.filteredBanks.isEmpty {
			VStack(alignment: .center, spacing: 16) {
				Text("Пока здесь пусто")
				Button("Добавить кэшбек") {
					store.send(.onAddCashbackTap)
				}
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
			.sheet(item: Binding(get: { store.cardToBeRenamed }, set: { _ in store.send(.dismissCardRename) })) { card in
				NavigationView {
					AddCardView(cardName: card.name) { cardName in
						store.send(.cardRenamed(cardName))
					}
					.navigationTitle("Переименовать карту")
					.navigationBarTitleDisplayMode(.inline)
				}
				.presentationDetents([.medium])
				.presentationBackground(.regularMaterial)
			}
		}
	}
}
