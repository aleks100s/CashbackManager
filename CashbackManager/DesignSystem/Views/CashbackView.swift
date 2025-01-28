//
//  CashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import SwiftUI

struct CashbackView: View {
	private let cashback: Cashback
	
	init(cashback: Cashback) {
		self.cashback = cashback
	}
	
	var body: some View {
		HStack(alignment: .center, spacing: .zero) {
			CategoryMarkerView(category: cashback.category)
				.padding(.trailing, 8)
			
			HStack(alignment: .center, spacing: .zero) {
				Text(cashback.percent, format: .percent)
					.padding(.trailing, 4)
					.frame(width: 52, alignment: .leading)
				Text(cashback.category.name)
			}
			
			Spacer()
		}
	}
}
