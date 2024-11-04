//
//  TrashbinView.swift
//  CashbackManager
//
//  Created by Alexander on 04.11.2024.
//

import Domain
import SwiftData
import SwiftUI

struct TrashbinView: View {
	@Query(filter: #Predicate<Card> { $0.isArchived })
	private var cards: [Card]

	@Query(filter: #Predicate<Domain.Category> { $0.isArchived })
	private var categories: [Domain.Category]
	
	@Environment(\.cardsService) private var cardsService
	@Environment(\.categoryService) private var categoryService

	var body: some View {
		List {
			if cards.isEmpty && categories.isEmpty {
				ContentUnavailableView("Корзина пуста", systemImage: "trashbin")
			} else {
				if !cards.isEmpty {
					Section("Удаленные карты") {
						ForEach(cards) { card in
							Text(card.name)
								.swipeActions(edge: .trailing, allowsFullSwipe: true) {
									Button("Восстановить", systemImage: "trash.slash") {
										cardsService?.unarchive(cards: [card])
									}
									.tint(.green)
								}
						}
						
						Button("Восстановить все", role: .cancel) {
							cardsService?.unarchive(cards: cards)
						}
					}
				}
				
				if !categories.isEmpty {
					Section("Удаленные категории") {
						ForEach(categories) { category in
							Text(category.name)
								.swipeActions(edge: .trailing, allowsFullSwipe: true) {
									Button("Восстановить", systemImage: "trash.slash") {
										categoryService?.unarchive(categories: [category])
									}
									.tint(.green)
								}
						}
						
						Button("Восстановить все", role: .cancel) {
							categoryService?.unarchive(categories: categories)
						}
					}
				}
			}
		}
		.navigationTitle("Корзина")
	}
}
