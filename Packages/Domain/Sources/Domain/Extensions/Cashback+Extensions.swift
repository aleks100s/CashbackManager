//
//  Cashback+Extensions.swift
//
//
//  Created by Alexander on 29.07.2024.
//

public extension Cashback {
	var description: String {
		if (percent * 1000).truncatingRemainder(dividingBy: 10) == 0 {
			"\(category.name) \(Int(percent * 100))%"
		} else {
			"\(category.name) \(String(format: "%.1f", percent * 100))%"
		}
	}
}
