//
//  Environment+CategoryService.swift
//
//
//  Created by Alexander on 20.08.2024.
//

import SwiftUI

private struct CategoryServiceKey: EnvironmentKey {
	static let defaultValue: CategoryService? = nil
}

extension EnvironmentValues {
	var categoryService: CategoryService? {
		get { self[CategoryServiceKey.self] }
		set { self[CategoryServiceKey.self] = newValue }
	}
}
