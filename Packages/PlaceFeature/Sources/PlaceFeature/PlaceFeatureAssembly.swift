//
//  PlaceFeatureAssembly.swift
//
//
//  Created by Alexander on 27.07.2024.
//

import AppIntents
import SwiftUI

public enum PlaceFeatureAssembly {
	public static func assemble(
		addPlaceIntent: any AppIntent,
		checkPlaceIntent: any AppIntent,
		addCategoryIntent: any AppIntent,
		checkPlaceCardIntent: any AppIntent
	) -> some View {
		Coordinator(addPlaceIntent: addPlaceIntent, checkPlaceIntent: checkPlaceIntent, addCategoryIntent: addCategoryIntent, checkPlaceCardIntent: checkPlaceCardIntent)
	}
}
