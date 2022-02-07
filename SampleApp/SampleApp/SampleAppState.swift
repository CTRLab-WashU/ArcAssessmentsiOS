//
//  SampleAppState.swift
//  SampleApp
//
//  Copyright © 2021 Sage Bionetworks. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// 2.  Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
//
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors
// may be used to endorse or promote products derived from this software without
// specific prior written permission. No license is granted to the trademarks of
// the copyright holders even if such marks are included in this software.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
