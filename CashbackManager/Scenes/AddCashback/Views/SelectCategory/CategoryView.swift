//
//  CategoryView.swift
//  CashbackManager
//
//  Created by Alexander on 27.06.2024.
//

import Domain
import SwiftUI

struct CategoryView: View {
	let category: Domain.Category
	
	var body: some View {
		HStack(alignment: .center) {
			CategoryMarkerView(category: category)
			Text(category.name)
			Spacer()
		}
	}
}	
