//
//  File.swift
//  DesignSystem
//
//  Created by Alexander on 24.10.2024.
//

public struct Toast: Equatable {
	public let title: String
	public let hasFeedback: Bool
	
	public init(title: String, hasFeedback: Bool = true) {
		self.title = title
		self.hasFeedback = hasFeedback
	}
}
