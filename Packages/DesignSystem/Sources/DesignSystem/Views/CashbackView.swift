//
//  CashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import Domain
import SwiftUI

public struct CashbackView: View {
	private let cashback: Cashback
	
	public init(cashback: Cashback) {
		self.cashback = cashback
	}
	
	public var body: some View {
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