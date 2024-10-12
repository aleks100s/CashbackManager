//
//  CardItemView.swift
//
//
//  Created by Alexander on 18.09.2024.
//

import DesignSystem
import Domain
import Shared
import SwiftUI

struct CardItemView: View {
	let card: Card
	
	var body: some View {
		Group {
			if card.isEmpty {
				Text(card.cashbackDescription)
			} else {
				VStack(alignment: .leading) {
					HStack {
						CategoriesStackView(cashback: card.sortedCashback)
						
						Spacer()
												
						Image(systemName: "creditcard")
							.foregroundStyle(Color(hex: card.color ?? ""))
					}
					
					Text(card.cashbackDescription)
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.contentShape(Rectangle())
	}
}
