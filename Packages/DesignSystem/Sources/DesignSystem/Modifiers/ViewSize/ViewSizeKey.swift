//
//  ViewSizeKey.swift
//
//
//  Created by Alexander on 21.07.2024.
//

import SwiftUI

private struct ViewSizeKey: EnvironmentKey {
	static let defaultValue = ViewSize.default
}

extension EnvironmentValues {
	var viewSize: ViewSize {
		get { self[ViewSizeKey.self] }
		set { self[ViewSizeKey.self] = newValue }
	}
}
