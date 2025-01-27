//
//  IncomeFeatureAssembly.swift
//  IncomeFeature
//
//  Created by Alexander on 11.10.2024.
//

import AppIntents
import SwiftUI

enum IncomeFeatureAssembly {
	static func assemble(createIncomeIntent: any AppIntent) -> some View {
		PaymentCoordinator(createIncomeIntent: createIncomeIntent)
	}
}
