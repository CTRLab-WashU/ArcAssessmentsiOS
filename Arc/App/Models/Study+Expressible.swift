//
//  Study+Expressible.swift
//  Arc
//
//  Created by Philip Hayes on 8/21/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import Foundation
extension StudyController : ThisStudyExpressible {
	public var nextTestCycle: String {
		if studyState == .inactive, let study = getUpcomingStudyPeriod() {
			let start = study.userStartDate?.localizedFormat(template: ACDateStyle.mediumWeekDayMonthDay.rawValue)
			let end = study.userEndDate?.localizedFormat(template: ACDateStyle.mediumWeekDayMonthDay.rawValue)
            return "\(String(describing: start)) - \(String(describing: end))"
		}
		
		return ""
	}
	
	public var week: Int {
		let previousStudiesCount = getPastStudyPeriods().count
		let currentStudy = (getCurrentStudyPeriod() != nil) ? 1 : 0
		return previousStudiesCount + currentStudy
	}
	public var studyState:StudyState {
		if let study = getCurrentStudyPeriod() {
			guard let start = study.userStartDate else {return .unknown}
			
			let day = Date().daysSince(date: start)
			if day == 0 {
				return .baseline
			}
			if study.studyID == 0 {
				return .activeBaseline
			}
			
			return .active
		} else {
			return .inactive
		}
		
		// return .complete

	}
	public var totalWeeks: Int {
		let totalStudies = getAllStudyPeriods().count
		
		return totalStudies
	}
	
	public var joinedDate: String {
		return beginningOfStudy.localizedFormat(template:ACDateStyle.longWeekdayMonthDay.rawValue)
	}
	
	public var finishDate: String {
		guard let lastCycle = getAllStudyPeriods().last else {
			return ""
		}
		guard let lasSession = lastCycle.sessions?.lastObject as? Session else {
			return ""
		}
		return lasSession.expirationDate!.localizedFormat(template:ACDateStyle.longWeekdayMonthDay.rawValue)
	}
	
	public var timeBetweenTestingWeeks: String {
		var components = DateComponents()
		
		var calendar = Calendar.current
		
		calendar.locale = Locale(identifier: Arc.shared.appController.locale.string)
		
		components.month = 2
		
		return DateComponentsFormatter.localizedString(from: components, unitsStyle: DateComponentsFormatter.UnitsStyle.full) ?? ""
	}
	
	
}


extension StudyController : ThisWeekExpressible {
	public var daysArray: [String] {
		var w:StudyPeriod?
		if let p = getCurrentStudyPeriod() {
			w = p
		}
		if let p = getPastStudyPeriods().last {
			w = p
		}
		guard let week = w else {
			return []
		}
		guard let start = week.userStartDate else {return []}
		guard let end = week.userEndDate else {return []}
		let formatter = DateFormatter()
		formatter.dateFormat = "EEEEE"
		formatter.locale = Arc.shared.appController.locale.getLocale()
		var values:[String] = []
		for i in 0 ... end.daysSince(date: start) {
			let date = start.addingDays(days: i)
			values.append(formatter.string(from: date))
			
		}
		
		return values
	
	}
	
	public var day: Int {
		switch getCurrentStudyPeriod() {
		case .some(let week):
			guard let start = week.userStartDate else {return 0}
			
			return Date().daysSince(date: start)
			
		default:
			return 0
			
		}
	}
	
	public var totalDays: Int {
		switch getCurrentStudyPeriod() {
		case .some(let week):
			guard let start = week.userStartDate else {return 0}
			guard let end = week.userEndDate else {return 0}

			return end.daysSince(date: start)
			
		default:
			return 0
		}

	}
	
	public var startDate: String {
		switch getCurrentStudyPeriod() {
		case .some(let week):
			guard var start = week.userStartDate else {return ""}
			if studyState == .baseline || studyState == .activeBaseline {
				start = start.addingDays(days: 1)
			}
			return start.localizedFormat(template:ACDateStyle.longWeekdayMonthDay.rawValue)
		default:
			return ""
		}
	}
	
	public var endDate: String {
		switch getCurrentStudyPeriod() {
		case .some(let week):
			guard let end = week.userEndDate else {return ""}
			
			return end.localizedFormat(template:ACDateStyle.longWeekdayMonthDay.rawValue)
		default:
			return ""
		}
	}
	
	
	
	
}
