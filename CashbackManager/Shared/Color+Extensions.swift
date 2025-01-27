//
//  File.swift
//  Shared
//
//  Created by Alexander on 12.10.2024.
//

import SwiftUI

extension Color {
	static func randomColor() -> Color {
		let red = Double.random(in: 0...1)
		let green = Double.random(in: 0...1)
		let blue = Double.random(in: 0...1)
		
		return Color(red: red, green: green, blue: blue)
	}

	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
		case 3: // RGB (12-bit)
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (255, 0, 0, 0)
		}
		
		self.init(
			.sRGB,
			red: Double(r) / 255,
			green: Double(g) / 255,
			blue: Double(b) / 255,
			opacity: Double(a) / 255
		)
	}
	
	func toHex() -> String? {
		// Convert Color to UIColor to access color components
		let uiColor = UIColor(self)
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		
		// Extract RGBA components
		uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		// Convert components to hex values
		let r = Int(red * 255)
		let g = Int(green * 255)
		let b = Int(blue * 255)
		let a = Int(alpha * 255)
		
		// Return hex string, depending on whether alpha is 1 or not
		if a < 255 {
			return String(format: "#%02X%02X%02X%02X", a, r, g, b)
		} else {
			return String(format: "#%02X%02X%02X", r, g, b)
		}
	}
}
