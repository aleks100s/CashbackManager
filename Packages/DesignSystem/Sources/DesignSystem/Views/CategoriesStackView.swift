//
//  CategoriesStackView.swift
//
//
//  Created by Alexander on 18.09.2024.
//

import Domain
import SwiftUI

public struct CategoriesStackView: View {
	private let cashback: [Cashback]
	
	@Environment(\.viewClass)
	private var viewClass
	
	private var trailingPadding: CGFloat {
		switch viewClass {
		case .default, .widget:
			-12
		case .favouriteWidget:
			-9
		}
	}
		
	public init(cashback: [Cashback]) {
		self.cashback = cashback
	}
	
	public var body: some View {
		HStack(alignment: .center, spacing: .zero) {
			ForEach(cashback, id: \.category.name) { cashback in
				CategoryMarkerView(category: cashback.category)
					.padding(.trailing, trailingPadding)
			}
		}
	}
}
