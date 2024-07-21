//
//  SelectCategoryView.swift
//  CashbackManager
//
//  Created by Alexander on 26.06.2024.
//

import CommonInput
import Domain
import SwiftUI

struct SelectCategoryView: View {
	let categories: [Domain.Category]
	let searchText: String
	let onSelect: (Domain.Category) -> Void
	let onSearchTextChange: (String) -> Void
	let onSaveCategoryButtonTapped: (String) -> Void
	
	@State private var isAddCategorySheetPresented = false
	
	var body: some View {
		List {
			ForEach(categories) { category in
				Button {
					onSelect(category)
				} label: {
					CategoryView(category: category)
						.contentShape(Rectangle())
				}
				.buttonStyle(PlainButtonStyle())
			}
		}
		.searchable(
			text: Binding(get: { searchText }, set: { onSearchTextChange($0) }),
			placement: .navigationBarDrawer(displayMode: .always),
			prompt: "Название категории"
		)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Добавить") {
					isAddCategorySheetPresented = true
				}
			}
		}
		.sheet(isPresented: $isAddCategorySheetPresented) {
			NavigationView {
				CommonInputView("Название категории") { categoryName in
					onSaveCategoryButtonTapped(categoryName)
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
