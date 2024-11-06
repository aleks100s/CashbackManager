//
//  SelectCategoryView.swift
//  CashbackManager
//
//  Created by Alexander on 26.06.2024.
//

import AppIntents
import CategoryService
import CommonInputSheet
import DesignSystem
import Domain
import SwiftData
import SwiftUI

public struct SelectCategoryView: View {
	private let addCategoryIntent: any AppIntent
	private let isSelectionMode: Bool
	private let onSelect: (Domain.Category) -> Void
	
	@State private var searchText = ""
	@State private var isAddCategorySheetPresented = false
	@Query(
		filter: #Predicate<Domain.Category> { !$0.isArchived },
		sort: [SortDescriptor<Domain.Category>(\.priority, order: .reverse),
			SortDescriptor<Domain.Category>(\.name, order: .forward)],
		transaction: Transaction(animation: .default)
	)
	private var categories: [Domain.Category]
	@Environment(\.dismiss) private var dismiss
	@Environment(\.categoryService) private var categoryService
	
	private var filteredCategories: [Domain.Category] {
		categories.filter { category in
			searchText.isEmpty ? true : category.name.localizedStandardContains(searchText) || (category.synonyms?.localizedStandardContains(searchText) ?? false)
		}
	}
	
	public init(
		addCategoryIntent: any AppIntent,
		isSelectionMode: Bool = true,
		onSelect: @escaping (Domain.Category) -> Void
	) {
		self.addCategoryIntent = addCategoryIntent
		self.isSelectionMode = isSelectionMode
		self.onSelect = onSelect
	}
	
	public var body: some View {
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
		NavigationView {
			CommonInputView("Название категории", text: searchText, intent: addCategoryIntent, hint: "Чтобы быстро добавить категорию") { categoryName in
				categoryService?.createCategory(name: categoryName)
				isAddCategorySheetPresented = false
			}
			.navigationTitle("Добавить категорию")
			.navigationBarTitleDisplayMode(.inline)
		}
		.presentationDetents([.medium])
		.presentationBackground(Color.cmScreenBackground)
	}
	
	private var addCategoryButton: some View {
		Button("Добавить свою категорию") {
			isAddCategorySheetPresented = true
		}
	}
	
	private func categoryButtonView(_ category: Domain.Category) -> some View {
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
