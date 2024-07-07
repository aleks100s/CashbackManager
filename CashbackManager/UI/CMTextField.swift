//
//  CMTextField.swift
//  CashbackManager
//
//  Created by Alexander on 07.07.2024.
//

import SwiftUI

struct CMTextField: View {
	let titleKey: LocalizedStringKey
	@Binding var text: String
	
	init(_ titleKey: LocalizedStringKey, text: Binding<String>) {
		self.titleKey = titleKey
		_text = text
	}
	
	var body: some View {
		TextField(titleKey, text: $text)
			.textFieldStyle(RoundedBorderTextFieldStyle())
	}
}
