//
//  CategoryMarkerView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import SwiftUI

struct CategoryMarkerView: View {
	let category: Category
	
	var body: some View {
		coloredCircle(Color(UIColor.systemBackground), side: 44)
			.overlay {
				coloredCircle(.red, side: 40)
					.overlay {
						Text(category.emoji)
					}
			}
	}
	
	@ViewBuilder
	private func coloredCircle(_ color: Color, side: CGFloat) -> some View {
		color.opacity(0.7)
			.frame(width: side, height: side)
			.clipShape(Circle())
	}
}

#Preview {
	CategoryMarkerView(category: PredefinedCategory.restaurants.asCategory)
}
