//
//  FilterItemView.swift
//  CashbackManager
//
//  Created by Alexander on 17.02.2025.
//

import SwiftUI

struct FilterItemView: View {
	let category: Category
	let isSelected: Bool
	let onTap: () -> Void
	
	var body: some View {
		HStack {
			Text(category.emoji)
			Text(category.name)
		}
		.padding(.horizontal, 8)
		.padding(.vertical, 4)
		.background(isSelected ? .blue : .gray)
		.clipShape(Capsule())
		.onTapGesture {
			onTap()
		}
	}
}
