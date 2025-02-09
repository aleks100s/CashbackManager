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
	@State private var categoryToEdit: Category?
	@Query(
		filter: #Predicate<Category> { !$0.isArchived },
		sort: [SortDescriptor<Category>(\.priority, order: .reverse),
			SortDescriptor<Category>(\.name, order: .forward)],
		transaction: Transaction(animation: .default)
	)
	private var categories: [Category]
	@Environment(\.dismiss) private var dismiss
	@Environment(\.categoryService) private var categoryService
	@Environment(\.toastService) private var toastService
	
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
			.sheet(item: $categoryToEdit) {
				editCategorySheet(category: $0)
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
						Group {
							if isSelectionMode {
								categoryButtonView(category)
							} else {
								CategoryView(category: category)
							}
						}
						.contextMenu {
							if !category.isNative {
								editCategoryButton(category: category)
							}
							
							Button("Удалить категорию", role: .destructive) {
								delete(category: category)
							}
						}
						.swipeActions(edge: .leading, allowsFullSwipe: true) {
							if !category.isNative {
								editCategoryButton(category: category)
							}
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
		CreateCategoryView(
			addCategoryIntent: addCategoryIntent,
			text: searchText
		) { categoryName, emoji, info in
			categoryService?.createCategory(name: categoryName, emoji: emoji, info: info)
			isAddCategorySheetPresented = false
			toastService?.show(Toast(title: "Категория добавлена"))
		}
		.presentationBackground(Color.cmScreenBackground)
	}
	
	private var addCategoryButton: some View {
		Button("Добавить категорию") {
			isAddCategorySheetPresented = true
		}
	}
	
	private func editCategoryButton(category: Category) -> some View {
		Button("Редактировать категорию") {
			categoryToEdit = category
		}
		.tint(.green)
	}
	
	private func editCategorySheet(category: Category) -> some View {
		CreateCategoryView(
			isEdit: true,
			addCategoryIntent: addCategoryIntent,
			text: category.name,
			emoji: category.emoji,
			info: category.info ?? ""
		) { categoryName, emoji, info in
			categoryService?.update(category: category, name: categoryName, emoji: emoji, info: info)
			categoryToEdit = nil
			toastService?.show(Toast(title: "Категория обновлена"))
		}
		.presentationBackground(Color.cmScreenBackground)
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
	
	private func deleteCategory(index: Int) {
		categoryService?.archive(category: categories[index])
	}
	
	private func delete(category: Category) {
		categoryService?.archive(category: category)
	}
}
