//
//  SelectCardScreen.swift
//  CashbackManager
//
//  Created by Alexander on 19.06.2024.
//

import SwiftUI
import DesignSystem

struct SelectCardScreen: View {
	@State private var store: SelectCardStore
	
	init(store: SelectCardStore) {
		self.store = store
	}
	
	var body: some View {
		ScrollView {
			LazyVStack(alignment: .leading, spacing: 16) {
				ForEach(store.bank.cards) { card in
					Button {
						store.send(.onCardSelected(card))
					} label: {
						CardView(card: card)
							.contextMenu {
								Text(card.name)
								Button {
									store.send(.onCardRename(card))
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
				
				Button("Добавить карту") {
					store.send(.onAddCardTapped)
				}
			}
			.padding(.horizontal, 12)
		}
		.background(Color.cmScreenBackground)
		.navigationTitle("Выбери карту")
		.onAppear {
			store.send(.viewDidAppear)
		}
		.sheet(isPresented: Binding(get: { store.isAddCardSheetPresented }, set: { _, _ in store.send(.dismissAddCard)})) {
			NavigationView {
				AddCardView { cardName in
					store.send(.saveCard(cardName))
				}
				.navigationTitle("Добавить новую карту")
				.navigationBarTitleDisplayMode(.inline)
			}
			.presentationDetents([.medium])
			.presentationBackground(.regularMaterial)
		}
		.sheet(item: Binding(get: { store.cardToBeRenamed }, set: { _ in store.send(.dismissRenameCard)})) { card in
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
