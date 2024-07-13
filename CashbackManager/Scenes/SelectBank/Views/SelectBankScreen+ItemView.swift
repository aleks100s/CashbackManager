//
//  SelectBankScreen+ItemView.swift
//  CashbackManager
//
//  Created by Alexander on 19.06.2024.
//

import Domain
import SwiftUI

extension SelectBankScreen {
	struct ItemView: View {
		let bank: Bank
		
		var body: some View {
			VStack(alignment: .leading, spacing: .zero) {
				Text(bank.name)
					.font(.title2.bold())
				
				HStack {
					if bank.cards.isEmpty {
						Text("Нет карт")
					} else {
						Text("Карты:")
						Text(bank.cardsList)
							.truncationMode(.tail)
					}
					Spacer()
				}
			}
			.lineLimit(1)
			.contentShape(Rectangle())
		}
	}
}

#Preview {
	SelectBankScreen.ItemView(bank: .alphabank)
}
