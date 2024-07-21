//
//  CategoryMarkerView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import Domain
import SwiftUI

public struct CategoryMarkerView: View {
	private let category: Domain.Category

	public init(category: Domain.Category) {
		self.category = category
	}
	
	public var body: some View {
		ColoredCircle(color: .cmStrokeColor, side: 44)
			.overlay {
				ColoredCircle(color: .red, side: 40)
					.overlay {
						Text(category.emoji)
							.font(.body)
					}
			}
	}
}

// MARK: - ColoredCircle

private struct ColoredCircle: View {
	let color: Color
	let side: CGFloat
	   
	var body: some View {
		color.opacity(0.7)
			.frame(width: side, height: side)
			.clipShape(Circle())
	}
}

#Preview {
	CategoryMarkerView(category: PredefinedCategory.restaurants.asCategory)
}
