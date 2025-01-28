//
//  PlaceMarkerView.swift
//
//
//  Created by Alexander on 30.07.2024.
//

import SwiftUI

struct PlaceMarkerView: View {
	private let name: String
	
	init(name: String) {
		self.name = name
	}
	
	var body: some View {
		ColoredCircle(color: .cmStrokeColor, side: 44)
			.overlay {
				ColoredCircle(color: .blue, side: 40)
					.overlay {
						Text(String(name.first ?? "?"))
							.font(.body)
							.foregroundStyle(.white)
					}
			}
	}
}
