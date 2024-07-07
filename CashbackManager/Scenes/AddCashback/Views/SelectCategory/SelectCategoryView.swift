//
//  SelectCategoryView.swift
//  CashbackManager
//
//  Created by Alexander on 26.06.2024.
//

import SwiftUI

struct SelectCategoryView: View {
	let categories: [Category]
	let searchText: String
	let onSelect: (Category) -> Void
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
			placement: .navigationBarDrawer(displayMode: .always)
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
				AddCategoryView { categoryName in
					onSaveCategoryButtonTapped(categoryName)
					isAddCategorySheetPresented = false
				}
			}
			.navigationTitle("Создать категорию")
			.navigationBarTitleDisplayMode(.inline)
			.presentationDetents([.medium])
		}
	}
}
