//
//  Environment+CardsService.swift
//
//
//  Created by Alexander on 20.08.2024.
//

import SwiftUI

private struct CardsServiceKey: EnvironmentKey {
	static let defaultValue: CardsService? = nil
}

public extension EnvironmentValues {
	var cardsService: CardsService? {
		get { self[CardsServiceKey.self] }
		set { self[CardsServiceKey.self] = newValue }
	}
}

