//
//  CategoryTrashbinView.swift
//  CashbackManager
//
//  Created by Alexander on 26.02.2025.
//

import SwiftData
import SwiftUI

struct CategoryTrashbinView: View {
	@Query(filter: #Predicate<Category> { $0.isArchived })
	private var categories: [Category]
	
	@Environment(\.categoryService) private var categoryService
	
	@State private var toast: Toast?

	var body: some View {
		List {
			if categories.isEmpty {
				ContentUnavailableView("Корзина пуста", systemImage: "trashbin")
			} else {
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
		.navigationTitle("Удаленные категории")
		.toast(item: $toast)
	}
}
