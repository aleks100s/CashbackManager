//
//  File.swift
//  Domain
//
//  Created by Alexander on 11.10.2024.
//

import Foundation
import SwiftData

@Model
public final class Income {
	public var id: UUID
	public var amount: Int
	public var date: Date
	public var source: Card?
	
	public init(id: UUID = UUID(), amount: Int, date: Date, source: Card?) {
		self.id = id
		self.amount = amount
		self.date = date
		self.source = source
	}
}
