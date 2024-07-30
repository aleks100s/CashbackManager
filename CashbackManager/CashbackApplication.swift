//
//  CashbackApplication.swift
//  CashbackManager
//
//  Created by Alexander on 10.06.2024.
//

import CashbackFeature
import Domain
import PlaceFeature
import SearchService
import Shared
import SwiftData
import SwiftUI

@main
struct CashbackApplication: App {
	private let container = AppFactory.provideModelContainer()

    var body: some Scene {
        WindowGroup {
			TabView {
				CashbackFeatureAssembly.assemble(container: container)
					.tabItem {
						Label("Кэшбек", systemImage: Constants.SFSymbols.rubleSign)
					}
				
				PlaceFeatureAssembly.assemble()
					.tabItem {
						Label("Места", systemImage: Constants.SFSymbols.mapPin)
					}
			}
			
        }
		.modelContainer(container)
		.environment(\.searchService, SearchService())
    }
}
