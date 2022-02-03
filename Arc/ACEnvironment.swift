//
//  Environment.swift
//  Arc
//
//  Created by Philip Hayes on 12/11/18.
//  Copyright © 2018 healthyMedium. All rights reserved.
//

import Foundation
public enum AuthStyle {
	case raterArcConfirm, arcConfirmRater, tfa, arcConfirm
}

public protocol ArcEnvironment {
    var priceTestType:PriceTestType {get}
    var gridTestType:GridTestType {get}
	
    var appController:AppController {get}
    
    var surveyController:SurveyController {get}
    
    var gridTestController:GridTestController {get}
    
    var pricesTestController:PricesTestController {get}
    
    var symbolsTestController:SymbolsTestController {get}
    
    var appNavigation:AppNavigationController {get}
    
    var controllerRegistry:ArcControllerRegistry {get}
    
    func configure()
}

public extension ArcEnvironment {
    var priceTestType:PriceTestType {return .normal}
	var gridTestType:GridTestType {return .normal}
    var appController:AppController {return AppController()}
    
    var surveyController:SurveyController {return SurveyController()}

    var gridTestController:GridTestController {return GridTestController()}
    
    var pricesTestController:PricesTestController {return PricesTestController()}
    
    var symbolsTestController:SymbolsTestController {return SymbolsTestController()}
    
    var controllerRegistry:ArcControllerRegistry {return ArcControllerRegistry()}


    func configure() {}
}

public struct ACEnvironment : ArcEnvironment {   
	public var appNavigation: AppNavigationController = BaseAppNavigationController()
}
