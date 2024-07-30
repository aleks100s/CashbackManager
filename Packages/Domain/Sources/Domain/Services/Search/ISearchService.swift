//
//  ISearchService.swift
//
//
//  Created by Alexander on 29.07.2024.
//

import UIKit

public protocol ISearchService {
	func index(card: Card)
	func index(cashback: Cashback, cardName: String, image: UIImage?)
	func index(place: Place, image: UIImage?)
	func deindex(card: Card)
	func deindex(cashback: Cashback)
	func deindex(place: Place)
}
