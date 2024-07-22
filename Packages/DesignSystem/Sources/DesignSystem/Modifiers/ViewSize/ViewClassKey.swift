//
//  ViewClassKey.swift
//
//
//  Created by Alexander on 21.07.2024.
//

import SwiftUI

private struct ViewClassKey: EnvironmentKey {
	static let defaultValue = ViewClass.default
}

extension EnvironmentValues {
	var viewClass: ViewClass {
		get { self[ViewClassKey.self] }
		set { self[ViewClassKey.self] = newValue }
	}
}
