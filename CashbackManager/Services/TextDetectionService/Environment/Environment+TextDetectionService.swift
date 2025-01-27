//
//  File.swift
//  
//
//  Created by Alexander on 19.09.2024.
//

import SwiftUI

private struct TextDetectionServiceKey: EnvironmentKey {
	static let defaultValue: TextDetectionService? = nil
}

extension EnvironmentValues {
	var textDetectionService: TextDetectionService? {
		get { self[TextDetectionServiceKey.self] }
		set { self[TextDetectionServiceKey.self] = newValue }
	}
}
