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
			CategoryMarkerView(category: category, color: .red)
			Text(category.name)
			Spacer()
			if category.info != nil {
				Image(systemName: "info.circle")
					.onTapGesture {
						isDescriptionAlertShown = true
					}
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
