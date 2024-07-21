//
//  BankView.swift
//  CashbackManager
//
//  Created by Alexander on 15.06.2024.
//

import Domain
import SwiftUI
import DesignSystem

struct BankView: View {
	enum Action {
		case select
		case rename
		case delete
	}
	let bank: Bank
	let onCardAction: (Card, Action) -> Void
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Text(bank.name)
				.foregroundStyle(.primary)
				.font(.title.bold())
			
			if bank.cards.isEmpty {
				Text("Пока нет кэшбека")
			} else {
				ForEach(bank.cards) { card in
					Button {
						onCardAction(card, .select)
					} label: {
						CardView(card: card)
					}
					.buttonStyle(.plain)
					.contextMenu {
						Text(card.name)
						Button {
							onCardAction(card, .rename)
						} label: {
							Text("Переименовать карту")
						}
						Button(role: .destructive) {
							onCardAction(card, .delete)
						} label: {
							Text("Удалить карту")
						}
					} preview: {
						CashbackListView(cashback: card.cashback)
					}
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.horizontal, 12)
		.padding(.vertical, 16)
	}
}
