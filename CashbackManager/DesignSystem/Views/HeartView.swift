//
//  File.swift
//  DesignSystem
//
//  Created by Alexander on 07.11.2024.
//

import SwiftUI

struct HeartView: View {
	private var isFavorite: Bool
	
	init(isFavorite: Bool) {
		self.isFavorite = isFavorite
	}

	var body: some View {
		Image(systemName: isFavorite ? "heart.fill" : "heart")
			.font(.title2)
			.foregroundStyle(isFavorite ? .red : .gray)
			.animation(.default, value: isFavorite)
			.keyframeAnimator(initialValue: HeartAnimationValues(), trigger: isFavorite, content: { view, values in
				view.scaleEffect(values.scale)
			}, keyframes: { values in
				KeyframeTrack(\.scale) {
					CubicKeyframe(2.0, duration: 0.3)
					CubicKeyframe(3.0, duration: 0.1)
					CubicKeyframe(2.0, duration: 0.1)
					CubicKeyframe(3.0, duration: 0.1)
					CubicKeyframe(2.0, duration: 0.1)
					CubicKeyframe(1.0, duration: 0.3)
				}
			})
			.onChange(of: isFavorite) {
				Task { @MainActor in
					try await Task.sleep(for: .seconds(0.4))
					hapticFeedback(.medium)
					try await Task.sleep(for: .seconds(0.1))
					hapticFeedback(.medium)
					try await Task.sleep(for: .seconds(0.1))
					hapticFeedback(.medium)
				}
			}
	}
}

struct HeartAnimationValues {
	var scale = 1.0
}
