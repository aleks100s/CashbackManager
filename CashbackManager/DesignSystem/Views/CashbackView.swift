//
//  CashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import SwiftUI

struct CashbackView: View {
	let cashback: Cashback
	
	@State private var isDescriptionAlertShown = false
	
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
			
			if cashback.category.info != nil {
				Button("", systemImage: "info.circle") {
					isDescriptionAlertShown = true
				}
				.buttonStyle(.plain)
				.contentShape(.rect)
			}
		}
		.alert(cashback.category.info ?? "", isPresented: $isDescriptionAlertShown) {
			Button("Ок") {
				isDescriptionAlertShown = false
			}
		}
	}
}
