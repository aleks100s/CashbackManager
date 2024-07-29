//
//  SearchService.swift
//  
//
//  Created by Alexander on 29.07.2024.
//

import CoreSpotlight
import Domain
import Shared
import UIKit

public struct SearchService: ISearchService {
	public init() {}
	
	public func index(card: Card) {
		let image = UIImage(systemName: Constants.SFSymbols.rubleSign)
		let attributeSet = createAttributes(title: card.name, description: card.cashbackDescription, image: image)
		index(id: card.id, attributes: attributeSet)
	}
	
	public func index(cashback: Cashback, cardName: String, image: UIImage?) {
		let attributeSet = createAttributes(title: cashback.description, description: cardName, image: image)
		index(id: cashback.id, attributes: attributeSet)
	}
	
	public func index(place: Place) {
		let image = UIImage(systemName: Constants.SFSymbols.mapPin)
		let attributeSet = createAttributes(title: place.name, description: place.category.name, image: image)
		index(id: place.id, attributes: attributeSet)
	}
	
	public func deindex(card: Card) {
		deindex(id: card.id)
	}
	
	public func deindex(cashback: Cashback) {
		deindex(id: cashback.id)
	}
	
	public func deindex(place: Place) {
		deindex(id: place.id)
	}
	
	private func createAttributes(
		title: String,
		description: String,
		image: UIImage? = nil
	) -> CSSearchableItemAttributeSet {
		let attributeSet = CSSearchableItemAttributeSet(itemContentType: UTType.text.identifier)
		attributeSet.title = title
		attributeSet.contentDescription = description
		attributeSet.thumbnailData = image?.pngData()
		return attributeSet
	}
	
	private func index(id: UUID, attributes: CSSearchableItemAttributeSet) {
		let item = CSSearchableItem(uniqueIdentifier: id.uuidString, domainIdentifier: Constants.appIdentifier, attributeSet: attributes)
		CSSearchableIndex.default().indexSearchableItems([item]) { error in
			if let error = error {
				print("Indexing error: \(error.localizedDescription)")
			} else {
				print("Search item successfully indexed!")
			}
		}
	}
	
	private func deindex(id: UUID) {
		CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id.uuidString]) { error in
			if let error = error {
				print("Deindexing error: \(error.localizedDescription)")
			} else {
				print("Search item successfully removed!")
			}
		}
	}
}
