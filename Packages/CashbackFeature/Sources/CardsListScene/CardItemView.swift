//
//  CardItemView.swift
//
//
//  Created by Alexander on 18.09.2024.
//

import CardsService
import DesignSystem
import Domain
import Shared
import SwiftUI

struct CardItemView: View {
	let card: Card
	let searchQuery: String
	
	@Environment(\.cardsService) private var cardsService
	
	var body: some View {
		Group {
			if card.isEmpty {
				Text(card.cashbackDescription)
			} else {
				VStack(alignment: .leading) {
					HStack {
						CategoriesStackView(cashback: card.sortedCashback(for: searchQuery))
						
						Spacer()
						
						HeartView(isFavorite: card.isFavorite)
							.onTapGesture {
								card.isFavorite.toggle()
								cardsService?.update(card: card)
							}
					}
					
					Text(card.cashbackDescription(for: searchQuery))
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.contentShape(Rectangle())
	}
}
