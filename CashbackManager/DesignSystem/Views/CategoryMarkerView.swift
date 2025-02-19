//
//  CategoryMarkerView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import SwiftUI

struct CategoryMarkerView: View {
	let category: Category
	let color: Color
	
	@Environment(\.viewClass)
	private var viewClass
	
	private var outerCircleSize: CGFloat {
		switch viewClass {
		case .default, .widget:
			44
		case .favouriteWidget:
			33
		}
	}
	
	private var innerCircleSize: CGFloat {
		switch viewClass {
		case .default, .widget:
			40
		case .favouriteWidget:
			30
		}
	}
	
	private var font: Font {
		switch viewClass {
		case .default, .widget:
			.body
		case .favouriteWidget:
			.callout
		}
	}
	
	var body: some View {
		ColoredCircle(color: .cmStrokeColor, side: outerCircleSize)
			.overlay {
				ColoredCircle(color: color, side: innerCircleSize)
					.overlay {
						Text(category.emoji)
							.font(font)
					}
			}
	}
}
