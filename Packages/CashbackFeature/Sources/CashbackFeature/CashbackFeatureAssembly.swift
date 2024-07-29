//
//  CashbackFeatureAssembly.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import CardsService
import SwiftData
import SwiftUI

public enum CashbackFeatureAssembly {
	public static func assemble(container: ModelContainer) -> some View {
		Coordinator()
			.environment(\.widgetURLParser, makeWidgetURLParser(with: container))
	}
	
	private static func makeWidgetURLParser(with container: ModelContainer) -> WidgetURLParser {
		WidgetURLParser(cardsService: CardsService(context: ModelContext(container)))
	}
}
