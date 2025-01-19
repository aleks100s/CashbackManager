//
//  ChartModel.swift
//  CashbackFeature
//
//  Created by Alexander on 19.01.2025.
//


import Foundation

struct ChartModel: Hashable, Identifiable {
	let id: UUID
	let date: Date
	let amount: Int
}
