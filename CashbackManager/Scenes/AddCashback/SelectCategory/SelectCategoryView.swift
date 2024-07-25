//
//  SelectCategoryView.swift
//  CashbackManager
//
//  Created by Alexander on 26.06.2024.
//

import CommonInput
import DesignSystem
import Domain
import SwiftData
import SwiftUI

struct SelectCategoryView: View {
	@Binding var searchText: String
	let onSelect: (Domain.Category) -> Void
	
	@State private var isAddCategorySheetPresented = false
	@Query private var categories: [Domain.Category]
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var context
	
	var body: some View {
		Group {
			if categories.isEmpty {
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
					ForEach(categories) { category in
						Button {
							onSelect(category)
							dismiss()
						} label: {
							CategoryView(category: category)
								.contentShape(Rectangle())
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
				Button("Добавить") {
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
