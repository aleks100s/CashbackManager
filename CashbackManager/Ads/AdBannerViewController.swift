//
//  AdBannerViewController.swift
//  CashbackManager
//
//  Created by Alexander on 25.01.2025.
//

import UIKit
import YandexMobileAds

final class AdBannerViewController: UIViewController {
	private lazy var adView: AdView = {
		let width = view.safeAreaLayoutGuide.layoutFrame.width
		let adSize = BannerAdSize.stickySize(withContainerWidth: width)
		let adView = AdView(adUnitID: "demo-banner-yandex", adSize: adSize)
		adView.translatesAutoresizingMaskIntoConstraints = false
		adView.delegate = self
		return adView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		adView.loadAd()
	}
	
	func showAd() {
		view.addSubview(adView)
		NSLayoutConstraint.activate([
			adView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			adView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
		])
	}
}

extension AdBannerViewController: AdViewDelegate {
	func adViewDidLoad(_ adView: AdView) {
		print("adViewDidLoad")
		showAd()
	}
	
	func adViewDidFailLoading(_ adView: AdView, error: any Error) {
		print("adViewDidFailLoading")
	}
}
