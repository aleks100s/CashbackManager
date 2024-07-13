//
//  CardView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import Domain
import SwiftUI

struct CardView: View {
	let card: Card
	
	@Environment(\.colorScheme) private var colorScheme
	private var shadowColor: Color {
		switch colorScheme {
		case .light:
			Color(UIColor.quaternarySystemFill).opacity(0.5)
		case .dark:
			.clear
		@unknown default:
			.clear
		}
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Text(card.name)
				.foregroundStyle(.secondary)
			
			if !card.cashback.isEmpty {
				ViewThatFits {					
					VStack(alignment: .leading) {
						HStack(alignment: .center, spacing: .zero) {
							ForEach(card.cashback, id: \.category.name) { cashback in
								CategoryMarkerView(category: cashback.category)
									.padding(.trailing, -12)
							}
						}
						
						Text(card.cashbackDescription)
					}
				}
			} else {
				Text(card.cashbackDescription)
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.horizontal, 12)
		.padding(.vertical, 12)
		.background(Color(UIColor.tertiarySystemBackground))
		.cornerRadius(10)
		.shadow(color: shadowColor, radius: 5, x: 0, y: 5)
	}
}

#Preview {
	CardView(card: .tinkoffBlack)
}
