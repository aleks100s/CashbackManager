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
	
	@Environment(\.viewSize) private var size
		
	public init(card: Card) {
		self.card = card
	}
	
	public var body: some View {
		VStack(alignment: .leading, spacing: vSpacing) {
			Text(card.name)
				.foregroundStyle(.secondary)
			
			if !card.cashback.isEmpty {
				VStack(alignment: .leading) {
					HStack(alignment: .center, spacing: .zero) {
						ForEach(card.cashback, id: \.category.name) { cashback in
							CategoryMarkerView(category: cashback.category)
								.padding(.trailing, -12)
						}
					}
					
					Text(card.cashbackDescription)
				}
			} else {
				Text(card.cashbackDescription)
			}
		}
		.font(size == .default ? .body : .caption)
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.horizontal, hPadding)
		.padding(.vertical, vPadding)
		.background(Color.cmCardBackground)
		.cornerRadius(10)
		.shadow(color: shadowColor, radius: 5, x: 0, y: 5)
	}
}

// MARK: - Size

private extension CardView {
	var vSpacing: CGFloat {
		switch size {
		case .default:
			16
		case .widget:
			8
		}
	}
	
	var hPadding: CGFloat {
		switch size {
		case .default:
			12
		case .widget:
			8
		}
	}
	
	var vPadding: CGFloat {
		switch size {
		case .default:
			12
		case .widget:
			8
		}
	}
}

#Preview {
	CardView(card: .tinkoffBlack)
}
