//
//  IPersistanceManagerMock.swift
//  CashbackManagerTests
//
//  Created by Alexander on 29.06.2024.
//

import Domain
@testable import Persistance

final class IPersistanceManagerMock: IPersistanceManager {
	var saveModelsCallsCount = 0
	var saveModelsReceivedKeys = [PersistanceKey]()
	var saveModelsReceivedModels = [[any Model]]()
	
	var readModelsCallsCount = 0
	var readModelsReceivedKeys = [PersistanceKey]()
	var readModelsReturnValue = [any Model]()
	
	func save(models: [some Model], for key: PersistanceKey) {
		saveModelsCallsCount += 1
		saveModelsReceivedKeys.append(key)
		saveModelsReceivedModels.append(models)
	}
	
	func readModels(for key: PersistanceKey) -> [any Model] {
		readModelsCallsCount += 1
		readModelsReceivedKeys.append(key)
		return readModelsReturnValue
	}
}
