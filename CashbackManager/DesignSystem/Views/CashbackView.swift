//
//  CashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import SwiftUI

struct CashbackView: View {
	let cashback: Cashback
	let color: Color
	
	@State private var isDescriptionAlertShown = false
	
	var body: some View {
		HStack(alignment: .center, spacing: .zero) {
			CategoryMarkerView(category: cashback.category, color: color)
				.padding(.trailing, 8)
			
			HStack(alignment: .center, spacing: .zero) {
				Text(cashback.percent, format: .percent)
					.padding(.trailing, 4)
					.frame(width: 52, alignment: .leading)
				Text(cashback.category.name)
			}
			
			Spacer()
			
			if cashback.category.info != nil {
				Image(systemName: "info.circle")
					.onTapGesture {
						isDescriptionAlertShown = true
					}
			}
		}
		.alert(cashback.category.info ?? "", isPresented: $isDescriptionAlertShown) {
			Button("Ок") {
				isDescriptionAlertShown = false
			}
		}
	}
}
