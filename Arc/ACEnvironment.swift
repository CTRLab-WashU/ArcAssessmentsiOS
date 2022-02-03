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
	var crashReporterApiKey:String? {get}
	var debuggableStates:[State] {get}
    var protectIdentity:Bool {get}
	var isDebug:Bool {get}
    var mockData:Bool {get}
    var blockApiRequests:Bool {get}
    var baseUrl:String? {get}
    var welcomeLogo:String? {get}
    var welcomeText:String? {get}
    var languageFile:String? {get}
    var privacyPolicyUrl:String? {get}
    var arcStartDays:Dictionary<Int, Int>? {get}
    var shouldDisplayDateReminderNotifications:Bool {get}
	
	var authenticationStyle:AuthStyle {get}
	var supportsScheduling:Bool {get}
	var supportsNotifications:Bool {get}
	var supportsChronotype:Bool {get}
	var supportsSignatures:Bool{get}
	var hidesChangeAvailabilityDuringTest:Bool {get}
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
    var crashReporterApiKey:String? {return nil}
    //This will trigger a flag that causes coredata to use a mock
    //persistent store, an in-memory database. 
	var mockData:Bool {return true}
	var debuggableStates:[State] {return []}
	var hidesChangeAvailabilityDuringTest:Bool {return false}

	var isDebug:Bool {return false}
	var blockApiRequests:Bool {return true}
	var arcStartDays:Dictionary<Int, Int>? {
		return [0: 0,   // Test Cycle A
			1: 89,  // Test Cycle B
			2: 179, // Test Cycle C
			3: 269, // Test Cycle D
			4: 359, // Test Cycle E
			5: 449, // Test Cycle F
			6: 539, // Test Cycle G
			7: 629, // Test Cycle H
			8: 719  // Test Cycle I
		];
		
	}
    var shouldDisplayDateReminderNotifications:Bool {return false}

	var authenticationStyle:AuthStyle {return .raterArcConfirm}
	var supportsScheduling:Bool {return true}
	var supportsNotifications:Bool {return true}
	var supportsChronotype:Bool {return true}
	var supportsSignatures:Bool{return true}
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
    public var protectIdentity: Bool = true

	public var baseUrl: String?

	public var welcomeLogo: String?
	
	public var welcomeText: String?
    
    public var languageFile: String?
	
	public var privacyPolicyUrl: String?
	
	public var appNavigation: AppNavigationController = BaseAppNavigationController()
}
