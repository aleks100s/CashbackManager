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

	@Environment(\.viewSize) private var size

	public init(category: Domain.Category) {
		self.category = category
	}
	
	public var body: some View {
		ColoredCircle(color: .cmStrokeColor, side: outerCircleSide)
			.overlay {
				ColoredCircle(color: .red, side: innerCircleSide)
					.overlay {
						Text(category.emoji)
							.font(size == .default ? .body : .caption)
					}
			}
	}
}

// MARK: - ColoredCircle

private extension CategoryMarkerView {
	struct ColoredCircle: View {
		let color: Color
		let side: CGFloat
		
		var body: some View {
			color.opacity(0.7)
				.frame(width: side, height: side)
				.clipShape(Circle())
		}
	}
}

// MARK: - Size

private extension CategoryMarkerView {
	var outerCircleSide: CGFloat {
		switch size {
		case .default:
			44
		case .widget:
			32
		}
	}
	
	var innerCircleSide: CGFloat {
		switch size {
		case .default:
			40
		case .widget:
			30
		}
	}
}

#Preview {
	CategoryMarkerView(category: PredefinedCategory.restaurants.asCategory)
}
