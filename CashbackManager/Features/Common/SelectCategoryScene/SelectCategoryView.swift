//
//  SelectCategoryView.swift
//  CashbackManager
//
//  Created by Alexander on 26.06.2024.
//

import AppIntents
import SwiftData
import SwiftUI

struct SelectCategoryView: View {
	private let addCategoryIntent: any AppIntent
	private let isSelectionMode: Bool
	private let onSelect: (Category) -> Void
	
	@State private var searchText = ""
	@State private var isAddCategorySheetPresented = false
	@Query(
		filter: #Predicate<Category> { !$0.isArchived },
		sort: [SortDescriptor<Category>(\.priority, order: .reverse),
			SortDescriptor<Category>(\.name, order: .forward)],
		transaction: Transaction(animation: .default)
	)
	private var categories: [Category]
	@Environment(\.dismiss) private var dismiss
	@Environment(\.categoryService) private var categoryService
	
	private var filteredCategories: [Category] {
		categories.filter { category in
			searchText.isEmpty ? true : category.name.localizedStandardContains(searchText) || (category.synonyms?.localizedStandardContains(searchText) ?? false)
		}
	}
	
	init(
		addCategoryIntent: any AppIntent,
		isSelectionMode: Bool = true,
		onSelect: @escaping (Category) -> Void
	) {
		self.addCategoryIntent = addCategoryIntent
		self.isSelectionMode = isSelectionMode
		self.onSelect = onSelect
	}
	
	var body: some View {
		contentView
			.navigationTitle(isSelectionMode ? "Выбор категории кэшбэка" : "Все категории")
			.navigationBarTitleDisplayMode(.inline)
			.searchable(
				text: $searchText,
				placement: .navigationBarDrawer(displayMode: .always),
				prompt: "Название категории"
			)
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					if isSelectionMode {
						addCategoryButton
					}
				}
				
				ToolbarItem(placement: .topBarTrailing) {
					if isSelectionMode {
						Button("Отмена") {
							dismiss()
						}
					} else {
						Button("Добавить") {
							isAddCategorySheetPresented = true
						}
					}
				}
			}
			.sheet(isPresented: $isAddCategorySheetPresented) {
				addCategorySheet
			}
	}
	
	private var contentView: some View {
		Group {
			if filteredCategories.isEmpty {
				VStack {
					ContentUnavailableView("Категории не найдены", systemImage: "checklist.unchecked")
					
					addCategoryButton
						.padding()
				}
			} else {
				List {
					ForEach(filteredCategories) { category in
						if isSelectionMode {
							categoryButtonView(category)
						} else {
							CategoryView(category: category)
						}
					}
					.onDelete { indexSet in
						for index in indexSet {
							deleteCategory(index: index)
						}
					}
				}
			}
		}
	}
	
	private var addCategorySheet: some View {
		CreateCategoryView(addCategoryIntent: addCategoryIntent, text: searchText) { categoryName, emoji, info in
			categoryService?.createCategory(name: categoryName, emoji: emoji, info: info)
			isAddCategorySheetPresented = false
		}
		.presentationBackground(Color.cmScreenBackground)
	}
	
	private var addCategoryButton: some View {
		Button("Добавить свою категорию") {
			isAddCategorySheetPresented = true
		}
	}
	
	private func categoryButtonView(_ category: Category) -> some View {
		Button {
			category.priority += 1
			onSelect(category)
			hapticFeedback(.light)
			dismiss()
		} label: {
			CategoryView(category: category)
		}
		.buttonStyle(PlainButtonStyle())
	}
	
	func deleteCategory(index: Int) {
		categoryService?.archive(category: categories[index])
	}
}
