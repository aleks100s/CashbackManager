//
//  AdBannerView.swift
//  CashbackManager
//
//  Created by Alexander on 25.01.2025.
//

import SwiftUI

public struct AdBannerView: UIViewControllerRepresentable {
	private let viewController: AdBannerViewController
	
	public init(bannerId: String) {
		viewController = AdBannerViewController(bannerId: bannerId)
	}

	public func makeUIViewController(context: Context) -> UIViewController {
		let size = viewController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		viewController.preferredContentSize = size
		return viewController
	}

	public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
