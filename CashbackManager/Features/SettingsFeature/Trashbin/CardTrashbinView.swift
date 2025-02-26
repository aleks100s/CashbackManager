//
//  CardTrashbinView.swift
//  CashbackManager
//
//  Created by Alexander on 04.11.2024.
//

import SwiftData
import SwiftUI

struct CardTrashbinView: View {
	@Query(filter: #Predicate<Card> { $0.isArchived })
	private var cards: [Card]
	
	@Environment(\.cardsService) private var cardsService
	
	@State private var toast: Toast?

	var body: some View {
		List {
			if cards.isEmpty {
				ContentUnavailableView("Корзина пуста", systemImage: "trashbin")
			} else {
				Section("Удаленные карты") {
					if !cards.isEmpty {
						ForEach(cards) { card in
							Text(card.name)
								.swipeActions(edge: .trailing, allowsFullSwipe: true) {
									Button("Восстановить", systemImage: "trash.slash") {
										cardsService?.unarchive(cards: [card])
										toast = Toast(title: "Карта восстановлена")
									}
									.tint(.green)
								}
						}
						
						Button("Восстановить все", role: .cancel) {
							cardsService?.unarchive(cards: cards)
							toast = Toast(title: "Все карты восстановлены")
						}
					} else {
						ContentUnavailableView("Нет удаленных карт", systemImage: "creditcard")
					}
				}
			}
		}
		.navigationTitle("Удаленные карты")
		.toast(item: $toast)
	}
}
