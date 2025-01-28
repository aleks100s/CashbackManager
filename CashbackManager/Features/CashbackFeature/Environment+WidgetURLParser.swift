//
//  Environment+WidgetURLParser.swift
//
//
//  Created by Alexander on 29.07.2024.
//

import SwiftUI

private struct WidgetURLParserKey: EnvironmentKey {
	static let defaultValue: WidgetURLParser? = nil
}

extension EnvironmentValues {
	var widgetURLParser: WidgetURLParser? {
		get { self[WidgetURLParserKey.self] }
		set { self[WidgetURLParserKey.self] = newValue }
	}
}
