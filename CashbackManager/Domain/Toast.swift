//
//  File.swift
//  DesignSystem
//
//  Created by Alexander on 24.10.2024.
//

struct Toast: Equatable {
	let title: String
	let hasFeedback: Bool
	
	init(title: String, hasFeedback: Bool = true) {
		self.title = title
		self.hasFeedback = hasFeedback
	}
}
