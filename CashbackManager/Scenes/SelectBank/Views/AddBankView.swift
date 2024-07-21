//
//  AddBankView.swift
//  CashbackManager
//
//  Created by Alexander on 20.06.2024.
//

import SwiftUI
import DesignSystem

struct AddBankView: View {
	@State var bankName: String = ""
	let onSaveButtonTapped: (String) -> Void

	@FocusState private var isFocused
	
	var body: some View {
		ScrollView {
			VStack(alignment: .center, spacing: 16) {
				CMTextField("Название банка", text: $bankName)
					.focused($isFocused)
				
				CMProminentButton("Сохранить") {
					onSaveButtonTapped(bankName)
				}
				.disabled(bankName.isEmpty)
				.buttonStyle(BorderedProminentButtonStyle())
			}
			.padding()
		}
		.onTapGesture {
			isFocused = false
		}
		.scrollDismissesKeyboard(.interactively)
	}
}
