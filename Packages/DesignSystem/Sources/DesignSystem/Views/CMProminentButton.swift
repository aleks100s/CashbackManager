//
//  CMProminentButton.swift
//  CashbackManager
//
//  Created by Alexander on 07.07.2024.
//

import SwiftUI

public struct CMProminentButton: View {
	private let title: String
	private let action: () -> Void
	
	public init(_ title: String, action: @escaping () -> Void) {
		self.title = title
		self.action = action
	}
	
	public var body: some View {
		Button(title, action: action)
			.buttonStyle(BorderedProminentButtonStyle())
	}
}
