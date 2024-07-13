//
//  CMTextField.swift
//  CashbackManager
//
//  Created by Alexander on 07.07.2024.
//

import SwiftUI

public struct CMTextField: View {
	private let titleKey: LocalizedStringKey
	@Binding private var text: String
	
	public init(_ titleKey: LocalizedStringKey, text: Binding<String>) {
		self.titleKey = titleKey
		_text = text
	}
	
	public var body: some View {
		TextField(titleKey, text: $text)
			.textFieldStyle(RoundedBorderTextFieldStyle())
	}
}
