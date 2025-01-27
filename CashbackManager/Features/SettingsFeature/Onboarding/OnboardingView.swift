//
//  OnboardingView.swift
//  CashbackManager
//
//  Created by Alexander on 11.01.2025.
//

import SwiftUI

struct OnboardingView: View {
	let onboardingPages: [OnboardingPage] = .cashbackOnoarding
	
	@Environment(\.dismiss)
	private var dismiss
	
	// MARK: - BODY
	
	var body: some View {
		TabView {
			ForEach(onboardingPages) { page in
				Image(page.image)
					.resizable()
					.scaledToFill()
					.ignoresSafeArea()
			}
		} //: TAB
		.tabViewStyle(PageTabViewStyle())
		.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
		.safeAreaInset(edge: .bottom) {
			Button("Пропустить") {
				dismiss()
			}
			.padding()
		}
	}
}
