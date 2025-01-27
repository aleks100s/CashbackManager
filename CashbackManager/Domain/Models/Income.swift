//
//  File.swift
//  Domain
//
//  Created by Alexander on 11.10.2024.
//

import Foundation
import SwiftData

@Model
final class Income: @unchecked Sendable {
	var id: UUID
	var amount: Int
	var date: Date
	var source: Card?
	
	init(id: UUID = UUID(), amount: Int, date: Date, source: Card?) {
		self.id = id
		self.amount = amount
		self.date = date
		self.source = source
	}
}
