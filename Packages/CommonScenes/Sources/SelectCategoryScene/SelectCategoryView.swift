//
//  SelectCategoryView.swift
//  CashbackManager
//
//  Created by Alexander on 26.06.2024.
//

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
	@Environment(\.modelContext) private var context
	
	private var filteredCategories: [Domain.Category] {
		categories.filter {
			searchText.isEmpty ? true : $0.name.localizedStandardContains(searchText)
		}
	}
	
	public init(onSelect: @escaping (Domain.Category) -> Void) {
		self.onSelect = onSelect
	}
	
	public var body: some View {
		Group {
			if filteredCategories.isEmpty {
				ZStack(alignment: .center) {
					VStack(alignment: .center, spacing: 16) {
						Text("Категории не найдены")
						
						CMProminentButton("Добавить свою") {
							isAddCategorySheetPresented = true
						}
					}
				}
				.background(Color.cmScreenBackground)
			} else {
				List {
					ForEach(filteredCategories) { category in
						Button {
							category.priority += 1
							onSelect(category)
							dismiss()
						} label: {
							CategoryView(category: category)
						}
						.buttonStyle(PlainButtonStyle())
					}
				}
			}
		}
		.searchable(
			text: $searchText,
			placement: .navigationBarDrawer(displayMode: .always),
			prompt: "Название категории"
		)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Создать") {
					isAddCategorySheetPresented = true
				}
			}
		}
		.sheet(isPresented: $isAddCategorySheetPresented) {
			NavigationView {
				CommonInputView("Название категории") { categoryName in
					let category = Category(name: categoryName, emoji: String(categoryName.first ?? "?"))
					context.insert(category)
					isAddCategorySheetPresented = false
				}
			}
			.navigationTitle("Создать категорию")
			.navigationBarTitleDisplayMode(.inline)
			.presentationDetents([.medium])
			.presentationBackground(.regularMaterial)
		}
	}
}
