//
//  CardView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import SwiftUI

struct CardView<AddonView: View>: View {
	private let card: Card
	private let addon: AddonView
	
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.viewClass) private var viewClass
	
	private var shadowColor: Color {
		switch colorScheme {
		case .light:
			.cmShadowColor
		case .dark:
			.clear
		@unknown default:
			.clear
		}
	}
	
	private var descriptionFont: Font {
		switch viewClass {
		case .default:
			.body
		case .widget:
			.callout
		case .favouriteWidget:
			.footnote
		}
	}
	
	init(card: Card, addon: () -> AddonView = { EmptyView() }) {
		self.card = card
		self.addon = addon()
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: viewClass.vSpacing) {
			HStack(alignment: .center, spacing: .zero) {
				Text(card.name)
					.foregroundStyle(.secondary)
					.font(descriptionFont)
					.bold(viewClass == .favouriteWidget)
				
				Spacer()
				
				addon
			}
			
			if !card.cashback.isEmpty {
				CategoriesStackView(cashback: card.cashback)
			}
			
			Text(card.cashbackDescription)
				.font(descriptionFont)
				.lineLimit(viewClass.lineLimit, reservesSpace: true)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.if(viewClass == .default) { view in
			view
				.padding(.horizontal, 12)
				.padding(.vertical, 12)
				.background(Color.cmCardBackground)
				.cornerRadius(10)
				.shadow(color: shadowColor, radius: 5, x: 0, y: 5)
		}
	}
}

private extension ViewClass {
	var vSpacing: CGFloat {
		switch self {
		case .default:
			16
		case .widget, .favouriteWidget:
			8
		}
	}
	
	var lineLimit: Int {
		switch self {
		case .default:
			0
		case .widget, .favouriteWidget:
			2
		}
	}
}
