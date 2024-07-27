//
//  CashbackApplication.swift
//  CashbackManager
//
//  Created by Alexander on 10.06.2024.
//

import CashbackFeature
import Domain
import PlaceFeature
import SwiftData
import SwiftUI

@main
struct CashbackApplication: App {
	private var container: ModelContainer {
		try! ModelContainer(for: Card.self, Cashback.self, Domain.Category.self, Place.self)
	}
	
    var body: some Scene {
        WindowGroup {
			TabView {
				CashbackFeatureAssembly.assemble(container: container)
					.tabItem {
						Label("Кэшбек", systemImage: "rublesign.circle")
					}
				
				PlaceFeatureAssembly.assemble()
					.tabItem {
						Label("Места", systemImage: "mappin.circle")
					}
			}
			
        }
		.modelContainer(container)
    }
}
