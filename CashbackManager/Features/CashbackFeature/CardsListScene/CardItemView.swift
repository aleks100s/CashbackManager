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
	
	private let color: Color
	
	init(card: Card, searchQuery: String) {
		self.card = card
		self.searchQuery = searchQuery
		color = Color(hex: card.color ?? "#E7E7E7")
	}
	
	var body: some View {
		VStack {
			HeaderView(card: card)
			
			CashbackDescriptionView(card: card, color: color, searchQuery: searchQuery)
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
			BackgroundView(color: color)
		}
	}
}

private extension CardItemView {
	struct HeaderView: View {
		let card: Card
		
		@Environment(\.cardsService) private var cardsService
		@Environment(\.toastService) private var toastService
		
		var body: some View {
			HStack {
				Text(card.name)
					.foregroundStyle(.secondary)
					.fontWeight(.semibold)
				
				Spacer()
				
				HeartView(isFavorite: card.isFavorite)
					.onTapGesture {
						onHeartTap()
					}
			}
		}
		
		private func onHeartTap() {
			card.isFavorite.toggle()
			cardsService?.update(card: card)
			toastService?.show(Toast(title: card.isFavorite ? "Добавлено в избранное" : "Удалено из избранного", hasFeedback: false))
		}
	}
	
	struct CashbackDescriptionView: View {
		let cashback: [Cashback]
		let color: Color
		let text: String
		let isEmpty: Bool
		
		init(card: Card, color: Color, searchQuery: String) {
			self.color = color
			self.cashback = card.filteredCashback(for: searchQuery)
			text = card.cashbackDescription(for: searchQuery)
			isEmpty = card.isEmpty
		}
		
		var body: some View {
			if isEmpty {
				Text(text)
			} else {
				VStack(alignment: .leading) {
					CategoriesStackView(cashback: cashback, color: color)
					
					Text(text)
				}
			}
		}
	}
	
	struct BackgroundView: View {
		let color: Color
		
		var body: some View {
			ZStack {
				RoundedRectangle(cornerRadius: 20, style: .continuous)
					.fill(color.opacity(0.4))
					.fill(.ultraThinMaterial)
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
