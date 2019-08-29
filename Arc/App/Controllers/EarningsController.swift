//
//  EarningsController.swift
//  Arc
//
//  Created by Philip Hayes on 8/22/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import Foundation

public protocol EarningsControllerDelegate {
	func didUpdateEarnings()
}
open class EarningsController {
	static public var overviewKey = "EarningsOverview"
	static public var detailKey = "EarningsDetail"

	static let earningsController = EarningsController()
	lazy var thisWeek:ThisWeekExpressible = {Arc.shared.studyController}()
	lazy var thisStudy:ThisStudyExpressible = {Arc.shared.studyController}()
	
	init() {
		NotificationCenter.default.addObserver(self, selector: #selector(sessionsUpdated(notification:)), name: .ACSessionUploadComplete, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(updateEarnings), name: .ACStartEarningsRefresh, object: nil)
	}
	@objc public func sessionsUpdated(notification:Notification) {
		let uploads = notification.object as? Set<Int64>
		assert(uploads != nil, "Wrong type supplied")
		if uploads?.isEmpty == true {
			
			updateEarnings()
			
		}
	}

	@objc private func updateEarnings() {
		OperationQueue().addOperation {
			
			//Perform request and fire notifications notifying the system of updates
			if let overview = Await(fetchEarnings).execute(EarningRequestData(cycle: nil, day: nil)) {
				Arc.shared.appController.lastFetched[EarningsController.overviewKey] = Date().timeIntervalSince1970
				Arc.shared.appController.store(value: overview, forKey: EarningsController.overviewKey)
				NotificationCenter.default.post(name: .ACEarningsUpdated, object: overview)
			}
			
			
			if let detail = Await(fetchEarningDetails).execute(()) {
				Arc.shared.appController.lastFetched[EarningsController.detailKey] = Date().timeIntervalSince1970
				Arc.shared.appController.store(value: detail, forKey: EarningsController.detailKey)
				NotificationCenter.default.post(name: .ACEarningDetailsUpdated, object: detail)
				
				
			}
			
			
			
		}
	}
}

fileprivate func fetchEarnings(request:EarningRequestData,  didFinish:@escaping (EarningOverview?)->()) {

	
	HMAPI.getEarningOverview.execute(data: request) { (urlResponse, data, err) in
		if let err = err {
			HMLog(err.toString())
			didFinish(nil)
			return
		}
		didFinish(data)
	}
}


fileprivate func fetchEarningDetails(request:Void,  didFinish:@escaping (EarningDetail?)->()) {
	
	
	HMAPI.getEarningDetail.execute(data: nil) { (urlResponse, data, err) in
		if let err = err {
			HMLog(err.toString())
			didFinish(nil)
			return
		}
		didFinish(data)
	}
}