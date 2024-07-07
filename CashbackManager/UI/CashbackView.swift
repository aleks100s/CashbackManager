//
//  CashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import SwiftUI

struct CashbackView: View {
	let cashback: Cashback
	
	var body: some View {
		HStack(alignment: .center, spacing: .zero) {
			CategoryMarkerView(category: cashback.category)
				.padding(.trailing, 8)
			HStack(alignment: .top, spacing: .zero) {
				Text(cashback.percent, format: .percent)
					.padding(.trailing, 4)
					.frame(width: 48, alignment: .leading)
				Text(cashback.category.name)
			}
			Spacer()
		}
	}
}

#Preview {
	CashbackView(cashback: .arbitrary(category: PredefinedCategory.restaurants.asCategory, percent: 0.05))
}
