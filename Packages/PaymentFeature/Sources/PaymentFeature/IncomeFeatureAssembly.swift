//
//  IncomeFeatureAssembly.swift
//  IncomeFeature
//
//  Created by Alexander on 11.10.2024.
//

import AppIntents
import SwiftUI

public enum IncomeFeatureAssembly {
	public static func assemble(createIncomeIntent: any AppIntent) -> some View {
		Coordinator(createIncomeIntent: createIncomeIntent)
	}
}
