//
//  Cashback.swift
//  CashbackManager
//
//  Created by Alexander on 11.06.2024.
//

import Foundation
import SwiftData

@Model
public final class Cashback {
	public let id: UUID
	public let category: Category
	public let percent: Double
	
	public init(id: UUID = UUID(), category: Category, percent: Double) {
		self.id = id
		self.category = category
		self.percent = percent
	}
}
