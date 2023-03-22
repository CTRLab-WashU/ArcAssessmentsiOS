//
//  HASDState.swift
//  HASD
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

/*
    Each state listed here is responsible for returning a viewcontroller or any of its subclasses. (TabViewController, NavigationViewController, etc.
*/

import Foundation
import UIKit

public enum ARCSageAppState : String, State, CaseIterable {
    
    case home, gridTest, priceTest, symbolsTest, testIntro, signatureStart, signatureEnd

    //Return a view controller w
    public func viewForState() -> UIViewController {
        let testIdx = 1
        ACState.testTaken = testIdx
        switch self {
            
        case .signatureStart:
            let vc:ACSignatureNavigationController = .get()
            vc.tag = 0
            
            vc.loadSurvey(template: "signature")
            return vc
        case .signatureEnd:
            let vc:ACSignatureNavigationController = .get()
            vc.tag = 1
            vc.loadSurvey(template: "signature")
            return vc
        case .testIntro:
            ACState.testCount = 1
            return ACState.testIntro.viewForState()
        case .gridTest:
            let controller:InstructionNavigationController = .get()
            var testType = "TestingIntro-Grids"
            if Arc.environment?.gridTestType == .extended {
                let vc:EXExtendedGridTestViewController
                vc = .get(nib:"ExtendedGridTestViewController")
                controller.nextVc = vc
                testType = "TestingIntro-Vb-Grids"
            } else {
                let vc:CRGridTestViewController
                vc = .get(nib:"GridTestViewController")
                controller.nextVc = vc
            }
            
            if (ACState.totalTestCountInSession > 1) {
                controller.titleOverride = "Test \(testIdx) of 3".localized(ACTranslationKey.testing_header_1)
                    .replacingOccurrences(of: "1", with: "\(testIdx)")
            } else {
                controller.titleOverride = ""
            }
            
            controller.load(instructions: testType)
            return controller
            
        case .priceTest:
            
            let vc:PricesTestViewController = .get()
            let controller:InstructionNavigationController = .get()
            controller.nextVc = vc
            controller.titleOverride = "Test 1 of 1"
            
            if Arc.environment?.priceTestType == .simplified ||
                Arc.environment?.priceTestType == .simplifiedCentered {
                controller.load(instructions: "TestingIntro-SimplifiedPrices")
            } else {
                controller.load(instructions: "TestingIntro-Prices")
            }
            
            if (ACState.totalTestCountInSession > 1) {
                controller.titleOverride = "Test \(testIdx) of 3".localized(ACTranslationKey.testing_header_1)
                    .replacingOccurrences(of: "1", with: "\(testIdx)")
                    .replacingOccurrences(of: "{Value2}", with: "3")
            } else {
                controller.titleOverride = ""
            }
            
            return controller
            
        case .symbolsTest:
            
            let vc:SymbolsTestViewController = .get()
            let controller:InstructionNavigationController = .get()
            controller.nextVc = vc
            
            if (ACState.totalTestCountInSession > 1) {
                controller.titleOverride = "Test \(testIdx) of 3".localized(ACTranslationKey.testing_header_1)
                    .replacingOccurrences(of: "1", with: "\(testIdx)")
                    .replacingOccurrences(of: "{Value2}", with: "3")
            } else {
                controller.titleOverride = ""
            }
            
            controller.load(instructions: "TestingIntro-Symbols")
            return controller
            
        case .home:
            return (Arc.shared.appNavigation as! ARCSageNavigationController).vcDelegate!.homeViewController()
        }
    }

    public func surveyTypeForState() -> SurveyType {
        switch self {
        case .symbolsTest:
            return .symbolsTest
        case .gridTest:
            return .gridTest
        case .priceTest:
            return .priceTest
        default:
            return .unknown
        }
    }
    
    public static func get<T:UIViewController>(nib:String? = nil, bundle:Bundle? = nil) -> T {
        var _bundle:Bundle? = bundle
        if bundle == nil {
            _bundle = Bundle.main

        }
        let vc = T(nibName: nib ?? String(describing: self), bundle: _bundle)
        
        return vc
    }
}
