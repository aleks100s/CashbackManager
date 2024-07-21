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
	private let size: ViewSize
	
	public init(category: Domain.Category, size: ViewSize = .default) {
		self.category = category
		self.size = size
	}
	
	public var body: some View {
		coloredCircle(Color(UIColor.systemBackground), side: outerCircleSide)
			.overlay {
				coloredCircle(.red, side: innerCircleSide)
					.overlay {
						Text(category.emoji)
							.font(size == .default ? .body : .caption)
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
