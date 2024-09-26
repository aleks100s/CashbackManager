//
//  CardItemView.swift
//
//
//  Created by Alexander on 18.09.2024.
//

import DesignSystem
import Domain
import SwiftUI

struct CardItemView: View {
	let card: Card
	
	var body: some View {
		VStack(alignment: .leading) {
			CategoriesStackView(cashback: card.sortedCashback)
			
			Text(card.cashbackDescription)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.contentShape(Rectangle())
	}
}
