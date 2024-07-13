//
//  Category.swift
//  CashbackManager
//
//  Created by Alexander on 14.06.2024.
//

public struct Category: Model {
	public let name: String
	public let emoji: String
	
	public var id: String {
		name
	}
	
	public init(name: String, emoji: String) {
		self.name = name
		self.emoji = emoji
	}
}
