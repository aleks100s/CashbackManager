//
//  Environment+SearchService.swift
//
//
//  Created by Alexander on 29.07.2024.
//

import SwiftUI

private struct SearchServiceKey: EnvironmentKey {
	static let defaultValue: SearchService? = nil
}

extension EnvironmentValues {
	var searchService: SearchService? {
		get { self[SearchServiceKey.self] }
		set { self[SearchServiceKey.self] = newValue }
	}
}
