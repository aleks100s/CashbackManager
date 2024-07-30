//
//  ColoredCircle.swift
//  
//
//  Created by Alexander on 30.07.2024.
//

import SwiftUI

struct ColoredCircle: View {
	let color: Color
	let side: CGFloat
	   
	var body: some View {
		Circle()
			.fill(color.opacity(0.7).gradient)
			.frame(width: side, height: side)
	}
}
