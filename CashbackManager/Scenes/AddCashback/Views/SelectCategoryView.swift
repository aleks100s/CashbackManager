//
//  SelectCategoryView.swift
//  CashbackApp
//
//  Created by Alexander on 26.06.2024.
//

import SwiftUI

struct SelectCategoryView: View {
	let categories: [Category]
	let searchText: String
	let onSelect: (Category) -> Void
	let onSearchTextChange: (String) -> Void
	
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
	}
}

#Preview {
	SelectCategoryView(categories: [.allPurchases, .entertainment, .fastfood], searchText: "") { _ in } onSearchTextChange: { _ in }
}
