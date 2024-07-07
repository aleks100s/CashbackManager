//
//  CMProminentButton.swift
//  CashbackManager
//
//  Created by Alexander on 07.07.2024.
//

import SwiftUI

struct CMProminentButton: View {
	let title: String
	let action: () -> Void
	
	init(_ title: String, action: @escaping () -> Void) {
		self.title = title
		self.action = action
	}
	
	var body: some View {
		Button(title, action: action)
			.buttonStyle(BorderedProminentButtonStyle())
	}
}
