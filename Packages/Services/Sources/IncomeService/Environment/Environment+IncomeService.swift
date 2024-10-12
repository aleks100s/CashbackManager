//
//  File.swift
//  Services
//
//  Created by Alexander on 12.10.2024.
//

import SwiftUI

private struct IncomeServiceKey: EnvironmentKey {
	static let defaultValue: IncomeService? = nil
}

public extension EnvironmentValues {
	var incomeService: IncomeService? {
		get { self[IncomeServiceKey.self] }
		set { self[IncomeServiceKey.self] = newValue }
	}
}
