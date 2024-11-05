//
//  TrashbinView.swift
//  CashbackManager
//
//  Created by Alexander on 04.11.2024.
//

import DesignSystem
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
	
	@State private var toast: Toast?

	var body: some View {
		List {
			if cards.isEmpty && categories.isEmpty {
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
				
				Section("Удаленные категории") {
					if !categories.isEmpty {
						
						ForEach(categories) { category in
							Text(category.name)
								.swipeActions(edge: .trailing, allowsFullSwipe: true) {
									Button("Восстановить", systemImage: "trash.slash") {
										categoryService?.unarchive(categories: [category])
										toast = Toast(title: "Категория восстановлена")
									}
									.tint(.green)
								}
						}
						
						Button("Восстановить все", role: .cancel) {
							categoryService?.unarchive(categories: categories)
							toast = Toast(title: "Все категории восстановлены")
						}
					} else {
						ContentUnavailableView("Нет удаленных категорий", systemImage: "checklist.unchecked")
					}
				}
			}
		}
		.navigationTitle("Корзина")
		.toast(item: $toast)
	}
}
