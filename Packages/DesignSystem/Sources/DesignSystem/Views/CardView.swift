//
//  CardView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import Domain
import SwiftUI

public struct CardView: View {
	private let card: Card
	
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.viewSize) private var size
	
	private var shadowColor: Color {
		switch colorScheme {
		case .light:
			.cmShadowColor
		case .dark:
			.clear
		@unknown default:
			.clear
		}
	}
		
	public init(card: Card) {
		self.card = card
	}
	
	public var body: some View {
		VStack(alignment: .leading, spacing: size.vSpacing) {
			Text(card.name)
				.foregroundStyle(.secondary)
			
			if !card.cashback.isEmpty {
				CategoriesView(cashback: card.cashback)
			}
			
			Text(card.cashbackDescription)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.if(size == .default) { view in
			view
				.padding(.horizontal, 12)
				.padding(.vertical, 12)
				.background(Color.cmCardBackground)
				.cornerRadius(10)
				.shadow(color: shadowColor, radius: 5, x: 0, y: 5)
		}
	}
}

private struct CategoriesView: View {
	let cashback: [Cashback]
	
	@Environment(\.viewSize) private var size
	
	var body: some View {
		HStack(alignment: .center, spacing: .zero) {
			ForEach(cashback, id: \.category.name) { cashback in
				CategoryMarkerView(category: cashback.category)
					.padding(.trailing, -12)
			}
		}
	}
}

private extension ViewSize {
	var vSpacing: CGFloat {
		switch self {
		case .default:
			16
		case .widget:
			8
		}
	}
}

#Preview {
	CardView(card: .tinkoffBlack)
}
