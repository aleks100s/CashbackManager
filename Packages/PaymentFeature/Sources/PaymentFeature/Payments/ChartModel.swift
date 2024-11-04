//
//  File.swift
//  PaymentFeature
//
//  Created by Alexander on 13.10.2024.
//

import Foundation

struct ChartModel: Hashable, Identifiable {
	let id: UUID
	let label: String
	let color: String

	var value: Int
}
