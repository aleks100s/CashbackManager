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
	public var id: UUID
	public var category: Domain.Category
	public var percent: Double
	
	public var description: String {
		if (percent * 1000).truncatingRemainder(dividingBy: 10) == 0 {
			"\(category.name) \(Int(percent * 100))%"
		} else {
			"\(category.name) \(String(format: "%.1f", percent * 100))%"
		}
	}
	
	public init(id: UUID = UUID(), category: Domain.Category, percent: Double) {
		self.id = id
		self.category = category
		self.percent = percent
	}
}
