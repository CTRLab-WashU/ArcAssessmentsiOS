//
//  Environment.swift
//  Arc
//
// Copyright (c) 2022 Washington University in St. Louis
//
// Washington University in St. Louis hereby grants to you a non-transferable,
// non-exclusive, royalty-free license to use and copy the computer code
// provided here (the "Software").  You agree to include this license and the
// above copyright notice in all copies of the Software.  The Software may not
// be distributed, shared, or transferred to any third party.  This license does
// not grant any rights or licenses to any other patents, copyrights, or other
// forms of intellectual property owned or controlled by
// Washington University in St. Louis.
//
// YOU AGREE THAT THE SOFTWARE PROVIDED HEREUNDER IS EXPERIMENTAL AND IS PROVIDED
// "AS IS", WITHOUT ANY WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, INCLUDING
// WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR
// PURPOSE, OR NON-INFRINGEMENT OF ANY THIRD-PARTY PATENT, COPYRIGHT, OR ANY OTHER
// THIRD-PARTY RIGHT.  IN NO EVENT SHALL THE CREATORS OF THE SOFTWARE OR WASHINGTON
// UNIVERSITY IN ST LOUIS BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL, OR
// CONSEQUENTIAL DAMAGES ARISING OUT OF OR IN ANY WAY CONNECTED WITH THE SOFTWARE,
// THE USE OF THE SOFTWARE, OR THIS AGREEMENT, WHETHER IN BREACH OF CONTRACT, TORT
// OR OTHERWISE, EVEN IF SUCH PARTY IS ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
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
