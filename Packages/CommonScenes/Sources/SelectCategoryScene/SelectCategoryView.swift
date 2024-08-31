//
//  SelectCategoryView.swift
//  CashbackManager
//
//  Created by Alexander on 26.06.2024.
//

import CategoryService
import CommonInputSheet
import DesignSystem
import Domain
import SwiftData
import SwiftUI

public struct SelectCategoryView: View {
	private let onSelect: (Domain.Category) -> Void
	
	@State private var searchText = ""
	@State private var isAddCategorySheetPresented = false
	@Query(sort: [
		SortDescriptor<Domain.Category>(\.priority, order: .reverse),
		SortDescriptor<Domain.Category>(\.name, order: .forward)
	])
	private var categories: [Domain.Category]
	@Environment(\.dismiss) private var dismiss
	@Environment(\.categoryService) private var categoryService
	
	private var filteredCategories: [Domain.Category] {
		categories.filter {
			searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText)
		}
	}
	
	public init(onSelect: @escaping (Domain.Category) -> Void) {
		self.onSelect = onSelect
	}
	
	public var body: some View {
		contentView
			.searchable(
				text: $searchText,
				placement: .navigationBarDrawer(displayMode: .always),
				prompt: "Название категории"
			)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					createButton
				}
			}
			.sheet(isPresented: $isAddCategorySheetPresented) {
				addCategorySheet
			}
	}
	
	private var contentView: some View {
		Group {
			if filteredCategories.isEmpty {
				HStack {
					Spacer()
					
					VStack(alignment: .center, spacing: 32) {
						Spacer()
						
						Text("Категории не найдены")
						
						addCategoryButton
						
						Spacer()
					}
					
					Spacer()
				}
				.background(Color.cmScreenBackground)
			} else {
				List {
					ForEach(filteredCategories) { category in
						categoryButtonView(category)
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
	
	private var addCategoryButton: some View {
		CMProminentButton("Добавить свою") {
			isAddCategorySheetPresented = true
		}
		.sensoryFeedback(.impact, trigger: isAddCategorySheetPresented)
	}
	
	private var addCategorySheet: some View {
		NavigationView {
			CommonInputView("Название категории") { categoryName in
				categoryService?.createCategory(name: categoryName)
				isAddCategorySheetPresented = false
			}
		}
		.navigationTitle("Создать категорию")
		.navigationBarTitleDisplayMode(.inline)
		.presentationDetents([.medium])
		.presentationBackground(.regularMaterial)
	}
	
	private var createButton: some View {
		Button("Создать") {
			isAddCategorySheetPresented = true
		}
		.sensoryFeedback(.impact, trigger: isAddCategorySheetPresented)
	}
	
	private func categoryButtonView(_ category: Domain.Category) -> some View {
		Button {
			category.priority += 1
			onSelect(category)
			dismiss()
		} label: {
			CategoryView(category: category)
		}
		.buttonStyle(PlainButtonStyle())
	}
	
	func deleteCategory(index: Int) {
		categoryService?.delete(category: categories[index])
	}
}
