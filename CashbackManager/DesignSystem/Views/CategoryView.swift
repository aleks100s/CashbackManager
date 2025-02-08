//
//  CategoryView.swift
//  CashbackManager
//
//  Created by Alexander on 27.06.2024.
//

import SwiftUI

struct CategoryView: View {
	let category: Category
	
	@State private var isDescriptionAlertShown = false
	
	var body: some View {
		HStack(alignment: .center) {
			CategoryMarkerView(category: category)
			Text(category.name)
			Spacer()
			if category.info != nil {
				Button("", systemImage: "info.circle") {
					isDescriptionAlertShown = true
				}
				.buttonStyle(.plain)
				.contentShape(.rect)
			}
		}
		.contentShape(Rectangle())
		.alert(category.info ?? "", isPresented: $isDescriptionAlertShown) {
			Button("Ок") {
				isDescriptionAlertShown = false
			}
		}
	}
}	
