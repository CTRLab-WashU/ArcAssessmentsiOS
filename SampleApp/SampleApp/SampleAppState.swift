//
//  SampleAppState.swift
//  SampleApp
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
import Arc
import UIKit

public enum SampleAppState: String, State, CaseIterable {
    
    case context, chronotype, wake, gridTest, priceTest, symbolsTest, signatureStart, signatureEnd, all
    
    public static var fullTest: [SampleAppState] {
        return [.signatureStart, .context, .chronotype, .wake, .gridTest, .priceTest, .symbolsTest, .signatureEnd]
    }
    
    //Return a view controller w
    public func viewForState() -> UIViewController {

        let testIdx = ((Arc.shared.appNavigation as? SampleAppNavigationController)?.getCognitiveAssessmentIndex(state: self) ?? 0) + 1
        ACState.testTaken = testIdx
        let surveyType = self.surveyTypeForState()
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
            case .gridTest:
                let vc:ExtendedGridTestViewController = .get(nib:"ExtendedGridTestViewController")
                let controller:InstructionNavigationController = .get()
                controller.nextVc = vc
                controller.titleOverride = "Test \(testIdx) of 3".localized(ACTranslationKey.testing_header_1)
                .replacingOccurrences(of: "1", with: "\(testIdx)")
                
                controller.load(instructions: "TestingIntro-Grids")
                return controller
            case .priceTest:
                let vc:PricesTestViewController = .get()
                let controller:InstructionNavigationController = .get()
                controller.nextVc = vc
                controller.titleOverride = "Test \(testIdx) of 3".localized(ACTranslationKey.testing_header_1)
                    .replacingOccurrences(of: "1", with: "\(testIdx)")
                    .replacingOccurrences(of: "{Value2}", with: "3")
                
                controller.load(instructions: "TestingIntro-Prices")
                return controller
            case .symbolsTest:
                
                let vc:SymbolsTestViewController = .get()
                let controller:InstructionNavigationController = .get()
                controller.nextVc = vc
                controller.titleOverride = "Test \(testIdx) of 3".localized(ACTranslationKey.testing_header_1)
                    .replacingOccurrences(of: "1", with: "\(testIdx)")
                    .replacingOccurrences(of: "{Value2}", with: "3")
                
                controller.load(instructions: "TestingIntro-Symbols")
                return controller
            case .context:
                let controller:BasicSurveyViewController = .init(file: "context", surveyType: surveyType)
                return controller
            case .chronotype:
                let controller:ACWakeSurveyViewController = .init(file:"chronotype", surveyType: surveyType)
                return controller
            case .wake:
                let controller:ACWakeSurveyViewController = .init(file:"wake", surveyType: surveyType)
                return controller
            default:
                return UIViewController()
        }
    }
    
    public func surveyTypeForState() -> SurveyType {
        switch self {
        case .chronotype:
            return .chronotype
        case .context:
            return .context
        case .wake:
            return .wake
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
    
    public func isCognitiveAssessment() -> Bool {
        switch self {
        case .symbolsTest:
            return true
        case .gridTest:
            return true
        case .priceTest:
            return true
        default:
            return false
        }
    }
}
