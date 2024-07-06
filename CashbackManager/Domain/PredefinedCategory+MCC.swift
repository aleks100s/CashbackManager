//
//  PredefinedCategory+MCC.swift
//  CashbackManager
//
//  Created by Alexander on 10.06.2024.
//

extension PredefinedCategory {
	var codes: [Int] {
		switch self {
		case .allPurchases:
			Array(0..<10_000)
		case .education:
			[8211, 8220, 8241, 8244, 8249, 8299, 8351, 8493, 8494]
		case .airplainTickets:
			Array(3000...3303) + [3308, 4304, 4511,4415, 4418, 4582, 4583]
		case .vipZone:
			[4583]
		case .carRent:
			Array(3351...3398) + [3351] + Array(3400...3439) + [3441, 7512, 7513, 7519]
		case .railRoadTickets:
			[4011, 4112]
		case .tourAgencies:
			[4722, 4723, 7032, 7033]
		case .cruises:
			[4583]
		case .hotels:
			Array(3501...3827) + Array(3832...3838) + [7011]
		case .dutyFreeShops:
			[5309]
		case .transport:
			[111, 4131, 4457, 4468, 4789, 5013, 5561, 5592, 5598, 5599, 7523]
		case .taxi:
			[4121]
		case .carSharing:
			[7512]
		case .autoServices:
			[5531, 5571, 7549, 5532, 5533, 7531, 7534, 7535, 7538, 7542]
		case .pharmacies:
			[5122, 5912]
		case .beautyAndSPA:
			[7230, 7297, 7298]
		case .cosmeticsAndParfume:
			[5977]
		case .houseAndRenovation:
			[1520, 1711, 1731, 1740, 1750, 1761, 1771, 5021, 5039, 5046, 5065, 5072, 5074, 5085, 5198, 5200, 5211, 5231, 5251, 5261, 5415, 5712, 5713, 5714, 5718, 5719, 7622, 7623, 7629, 7641, 7692, 7699]
		case .art:
			[5932, 5937] + Array(5970...5973)
		case .books:
			[2741, 5111, 5192, 5942, 5994]
		case .zooGoods:
			[0742, 5995]
		case .cinema:
			[7829, 7832, 7841]
		case .entertainment:
			[7911, 7922, 7929, 7932, 7933, 7992, 7993, 7994, 7996, 7998, 7999, 8664]
		case .exhibitionsAndMuseums:
			[7991]
		case .medicineServices:
			[5296, 5975, 8041, 8044, 8676]
		case .fitness:
			[7941, 7997]
		case .clinicsAndEsthetics:
			[5976, 8011, 8031, 8042, 8043, 8049, 8050, 8062, 8099]
		case .dentist:
			[8021, 8071]
		case .music:
			[5733, 5735]
		case .supermarkets:
			[5297, 5298, 5300, 5411, 5412, 5422, 5441, 5451, 5462, 5499, 5715]
		case .shops:
			[5099, 5131, 5310, 5311, 5331, 5734, 5942, 5943, 5945, 5948, 5978]
		case .electronicDevices:
			[5722, 5732, 5946]
		case .restaurants:
			[5811, 5812, 5813]
		case .fastfood:
			[5814]
		case .communicationAndTelecom:
			[4896, 4897, 4898, 4901, 4902, 7375, 7894]
		case .photoAndVideo:
			[5045, 5544, 7332, 7333, 7338, 7339, 7395]
		case .souvenirs:
			[5947]
		case .flowers:
			[5193, 5992]
		case .sportGoods:
			[5655, 5940, 5941]
		case .clothesAndShoes:
			[5137, 5139, 5611, 5621, 5631, 5641, 5651, 5661, 5681, 5691, 5697, 5698, 5699, 5931, 5944, 5949, 5950, 7631]
		case .sbp:
			[]
		}
	}
}
