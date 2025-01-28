//
//  Environment+PlaceService.swift
//
//
//  Created by Alexander on 20.08.2024.
//

import SwiftUI

private struct PlaceServiceKey: EnvironmentKey {
	static let defaultValue: PlaceService? = nil
}

extension EnvironmentValues {
	var placeService: PlaceService? {
		get { self[PlaceServiceKey.self] }
		set { self[PlaceServiceKey.self] = newValue }
	}
}
