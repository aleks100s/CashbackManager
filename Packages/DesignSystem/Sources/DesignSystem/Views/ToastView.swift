//
//  File.swift
//  DesignSystem
//
//  Created by Alexander on 23.10.2024.
//

import SwiftUI

public struct ToastView: View {
	private let title: String
	
	public init(title: String) {
		self.title = title
	}
	
	public var body: some View {
		Text(title)
			.padding()
			.background(.regularMaterial)
			.clipShape(.capsule)
	}
}
