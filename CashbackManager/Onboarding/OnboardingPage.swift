//
//  OnboardingPage.swift
//  CashbackManager
//
//  Created by Alexander on 11.01.2025.
//

import DeveloperToolsSupport
import Foundation

struct OnboardingPage: Identifiable {
	let id = UUID()
	let image: ImageResource
}

extension [OnboardingPage] {
	static let cashbackOnoarding: [OnboardingPage] = [
		.init(image: .page1),
		.init(image: .page2),
		.init(image: .page3),
		.init(image: .page4),
		.init(image: .page5),
		.init(image: .page6),
		.init(image: .page7),
		.init(image: .page8),
	]
}
