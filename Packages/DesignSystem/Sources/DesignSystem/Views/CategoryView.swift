//
//  CategoryView.swift
//  CashbackManager
//
//  Created by Alexander on 27.06.2024.
//

import Domain
import SwiftUI

public struct CategoryView: View {
	private let category: Domain.Category
	
	public init(category: Domain.Category) {
		self.category = category
	}
	
	public var body: some View {
		HStack(alignment: .center) {
			CategoryMarkerView(category: category)
			Text(category.name)
			Spacer()
		}
	}
}	
