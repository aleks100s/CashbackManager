//
//  FilterView.swift
//  CashbackManager
//
//  Created by Alexander on 18.02.2025.
//

import SwiftUI

struct FilterView: View {
	let popularCategories: [Category]
	
	@Binding var selectedCategory: Category?
	
	var body: some View {
		ScrollView(.horizontal) {
			LazyHStack {
				ForEach(popularCategories) { category in
					FilterItemView(
						category: category,
						isSelected: selectedCategory == category
					) {
						withAnimation {
							if selectedCategory == category {
								selectedCategory = nil
							} else {
								selectedCategory = category
							}
						}
						hapticFeedback(.light)
					}
				}
			}
			.padding(.horizontal, 16)
		}
		.scrollIndicators(.hidden)
		.fixedSize(horizontal: false, vertical: true)
		.padding(.vertical, 4)
		.background(.regularMaterial)
	}
}
