//
//  PlaceFeatureAssembly.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import AppIntents
import SwiftUI

enum PlaceFeatureAssembly {
	static func assemble(
		addPlaceIntent: any AppIntent,
		checkPlaceIntent: any AppIntent,
		addCategoryIntent: any AppIntent,
		checkPlaceCardIntent: any AppIntent
	) -> some View {
		PlaceCoordinator(addPlaceIntent: addPlaceIntent, checkPlaceIntent: checkPlaceIntent, addCategoryIntent: addCategoryIntent, checkPlaceCardIntent: checkPlaceCardIntent)
	}
}
