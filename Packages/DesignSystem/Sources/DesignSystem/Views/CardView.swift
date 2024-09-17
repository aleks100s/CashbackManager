//
//  CardView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import Domain
import SwiftUI

public struct CardView<AddonView: View>: View {
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
		}
	}
	
	public init(card: Card, addon: () -> AddonView = { EmptyView() }) {
		self.card = card
		self.addon = addon()
	}
	
	public var body: some View {
		VStack(alignment: .leading, spacing: viewClass.vSpacing) {
			HStack(alignment: .center, spacing: .zero) {
				Text(card.name)
					.foregroundStyle(.secondary)
				
				Spacer()
				
				addon
			}
			
			if !card.cashback.isEmpty {
				CategoriesStackView(cashback: card.cashback)
			}
			
			Text(card.cashbackDescription)
				.font(descriptionFont)
				.if(viewClass == .widget) {
					$0.lineLimit(2, reservesSpace: true)
				}
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
		case .widget:
			8
		}
	}
}
