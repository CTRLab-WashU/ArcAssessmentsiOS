//
//  ACState.swift
//  Arc
//
//  Created by Philip Hayes on 11/9/18.
//  Copyright © 2018 healthyMedium. All rights reserved.
//

import UIKit
public enum ACState : String, State, CaseIterable {
	
	case about, home, context, gridTest, priceTest, symbolsTest, testIntro, thankYou
	
	static var configuration: [ACState] {return [] }
	
	static var surveys:[ACState] { return  [.context] }
	
	static var tests:[ACState] {return [.gridTest, .priceTest, .symbolsTest] }
	static public var testCount = 0
	static public var testTaken: Int = 0
	
	public func surveyTypeForState() -> SurveyType {
		return SurveyType(rawValue: self.rawValue) ?? .unknown
	}
	
	public func viewForState() -> UIViewController {
		
		let home:UIViewController = UIViewController()
		
		var newController:UIViewController = home
		
		switch self {
            case .about:
                newController = UIViewController()
                
            case .context:
                let controller:SurveyNavigationViewController = .get()
                controller.participantId = Arc.shared.participantId
                controller.surveyType = .context
                controller.loadSurvey(template: "context")
                
                newController = controller

            case .testIntro:
                let controller:InstructionNavigationController = .get()
                controller.nextState = Arc.shared.appNavigation.nextAvailableSurveyState()
                
                controller.load(instructions: "TestingIntro")
                newController = controller
            case .gridTest:
                let controller:InstructionNavigationController = .get()
                if Arc.environment?.gridTestType == .extended {
                    let vc:ExtendedGridTestViewController = .get()
                    controller.nextVc = vc
                } else {
                    let vc:GridTestViewController = .get()
                    controller.nextVc = vc
                }
                controller.titleOverride = "Test \(ACState.testTaken + 1) of 3"
                
                controller.load(instructions: "TestingIntro-Grids")
                newController = controller
                
            case .priceTest:
                
                let vc:PricesTestViewController = .get()
                let controller:InstructionNavigationController = .get()
                controller.nextVc = vc
                controller.titleOverride = "Test \(ACState.testTaken + 1) of 3"
                
                controller.load(instructions: "TestingIntro-Prices")
                
                newController = controller
            case .symbolsTest:
                
                let vc:SymbolsTestViewController = .get()
                let controller:InstructionNavigationController = .get()
                controller.nextVc = vc
                controller.titleOverride = "Test \(ACState.testTaken + 1) of 3"
                
                controller.load(instructions: "TestingIntro-Symbols")
                
                newController = controller
            case .home:
                break
            case .thankYou:
                let vc:FinishedNavigationController = FinishedNavigationController(file: "finished")
                ACState.testCount = 0
                newController = vc
        }
		
		return newController

	}	
}
