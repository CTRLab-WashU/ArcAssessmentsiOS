//
//  ACState.swift
// Arc
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

import UIKit
public enum ACState : String, State, CaseIterable {
	
	case about, home, contact, context, gridTest, priceTest, symbolsTest, testIntro, thankYou
	
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
            case .home, .contact:
                break
            case .thankYou:
                let vc:FinishedNavigationController = FinishedNavigationController(file: "finished")
                ACState.testCount = 0
                newController = vc
        }
		
		return newController

	}	
}
