//
//  File.swift
//  DesignSystem
//
//  Created by Alexander on 23.10.2024.
//

import SwiftUI

struct ToastView: View {
	private let title: String
	
	init(title: String) {
		self.title = title
	}
	
	var body: some View {
		Text(title)
			.padding()
			.background(.regularMaterial)
			.clipShape(.capsule)
	}
}
