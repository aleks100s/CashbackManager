//
//  CardItemView.swift
//
//
//  Created by Alexander on 18.09.2024.
//

import SwiftUI

struct CardItemView: View {
	let card: Card
	let searchQuery: String
	
	@Environment(\.cardsService) private var cardsService
	@Environment(\.toastService) private var toastService
	
	private var color: Color {
		Color(hex: card.color ?? "#E7E7E7")
	}
	
	var body: some View {
		VStack {
			HStack {
				Text(card.name)
					.foregroundStyle(.secondary)
					.fontWeight(.semibold)
				
				Spacer()
				
				HeartView(isFavorite: card.isFavorite)
					.onTapGesture {
						card.isFavorite.toggle()
						cardsService?.update(card: card)
						toastService?.show(Toast(title: card.isFavorite ? "Добавлено в избранное" : "Удалено из избранного", hasFeedback: false))
					}
			}
			
			Group {
				if card.isEmpty {
					Text(card.cashbackDescription)
				} else {
					VStack(alignment: .leading) {
						CategoriesStackView(cashback: card.filteredCashback(for: searchQuery), color: color)
						
						Text(card.cashbackDescription(for: searchQuery))

					}
				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.foregroundStyle(.primary.opacity(0.8))
			.fontWeight(.medium)
			
			Text(card.currencySymbol)
				.fontWeight(.semibold)
				.fontWidth(.expanded)
				.foregroundStyle(.secondary)
				.frame(maxWidth: .infinity, alignment: .trailing)
		}
		.contentShape(Rectangle())
		.padding(.horizontal, 16)
		.padding(.vertical, 12)
		.background {
			ZStack {
				RoundedRectangle(cornerRadius: 20, style: .continuous)
					.fill(color.opacity(0.4))
				
				RoundedRectangle(cornerRadius: 20, style: .continuous)
					.fill(.ultraThinMaterial)
				
				RoundedRectangle(cornerRadius: 20, style: .continuous)
					.fill(
						.linearGradient(
							colors: [
								.white.opacity(0.25),
								.white.opacity(0.05)
							],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					)
					.blur(radius: 5)
				
				RoundedRectangle(cornerRadius: 20, style: .continuous)
					.stroke(
						.linearGradient(
							colors: [
								.secondary.opacity(0.2),
								.clear,
								color.opacity(0.2),
								color.opacity(0.5)
							],
							startPoint: .top,
							endPoint: .bottom
						),
						lineWidth: 3
					)
			}
			.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
		}
	}
}
