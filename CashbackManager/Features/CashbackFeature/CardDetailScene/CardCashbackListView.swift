//
//  CardCashbackListView.swift
//  CashbackManager
//
//  Created by Alexander on 14.02.2025.
//

import SwiftUI

struct CardCashbackListView: View {
	private let onEditCashbackTap: (Cashback) -> Void
	private let deleteCashback: (Cashback) -> Void

	@State private var cashback: [Cashback]
	
	@Environment(\.cardsService)
	private var cardsService
	
	init(
		cashback: [Cashback],
		onEditCashbackTap: @escaping (Cashback) -> Void,
		deleteCashback: @escaping (Cashback) -> Void
	) {
		_cashback = State(initialValue: cashback.sorted(by: { $0.order < $1.order }))
		self.onEditCashbackTap = onEditCashbackTap
		self.deleteCashback = deleteCashback
	}
	
	var body: some View {
		ForEach(cashback) { cashback in
			HStack {
				Image(systemName: "line.3.horizontal") // Иконка перетаскивания
					.foregroundColor(.gray)
				
				CashbackView(cashback: cashback)
					.contentShape(.rect)
					.onTapGesture {
						onEditCashbackTap(cashback)
					}
			}
			.swipeActions(edge: .leading, allowsFullSwipe: true) {
				editCashbackButton(cashback: cashback)
			}
		}
		.onDelete { indexSet in
			for index in indexSet {
				deleteCashback(cashback[index])
			}
		}
		.onMove { source, destination in
			cashback.move(fromOffsets: source, toOffset: destination)
			cashback.indices.forEach { index in
				cashback[index].order = index
			}
		}
	}
	
	private func editCashbackButton(cashback: Cashback) -> some View {
		Button("Редактировать кэшбэк") {
			onEditCashbackTap(cashback)
		}
		.tint(.green)
	}
}
