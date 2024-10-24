//
//  File.swift
//  DesignSystem
//
//  Created by Alexander on 24.10.2024.
//

public struct Toast: Equatable {
	let title: String
	let value: String
	
	public init(title: String, value: String) {
		self.title = title
		self.value = value
	}
}
