//
//  TKWakeSurveyViewController.swift
//  NSARC
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

open class ACWakeSurveyViewController: BasicSurveyViewController {
    enum WakeSurveyQuestion : String {
        case bedTimeLastNight = "wake_1"
        case sleepTimeLastNight = "wake_2"
        case wakeTimeThisMorning = "wake_4"
        case outOfBedTimeThisMorning = "wake_5"
        case workSleep = "chronotype_3"
        case workWake = "chronotype_4"
        case nonworkSleep = "chronotype_5"
        case nonworkWake = "chronotype_6"
        case nonworkSleep2 = "chronotype_7"
        case nonworkWake2 = "chronotype_8"

        case other
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shouldShowHelpButton = false
    }
	
    open override func didPresentQuestion(input: SurveyInput?, questionId: String)
    {
		super.didPresentQuestion(input: input, questionId: questionId)
        guard let input = input else { return; }
        
        let question = WakeSurveyQuestion(rawValue: questionId) ?? .other
        
        guard question != .other else {return}
        
        let date = Date()
        let startHourDate = Calendar.current.date(bySettingHour: Arc.shared.availabilityStartHour, minute: 0, second: 0, of: date)!
        let endHourDate = Calendar.current.date(bySettingHour: Arc.shared.availabilityEndHour, minute: 0, second: 0, of: date)!
        
        let formatter = DateFormatter()
        formatter.defaultDate = Date()
        formatter.dateFormat = "h:mm a"

        let availabilityStartStr = formatter.string(from: startHourDate)
        let availabilityEndStr = formatter.string(from: endHourDate)

        switch question {
        
        case .bedTimeLastNight, .sleepTimeLastNight:
            
            guard getAnswerFor(question: question) == nil else {return}

            input.setValue(AnyResponse(type: .time, value: availabilityEndStr))
            
            enableNextButton()
        
        
        
        case .wakeTimeThisMorning, .outOfBedTimeThisMorning, .workWake:
            
            guard getAnswerFor(question: question) == nil else {return}
            
            input.setValue(AnyResponse(type: .time, value: availabilityStartStr))
            
            enableNextButton()
        
        
        
        case .workSleep:
            
            guard getAnswerFor(question: question) == nil else {return}
            
            input.setValue(AnyResponse(type: .time, value: availabilityEndStr))
            
            enableNextButton()
        
        
        
        case .nonworkWake, .nonworkWake2:
            
            guard getAnswerFor(question: question) == nil else {return}
            
            input.setValue(AnyResponse(type: .time, value: availabilityStartStr))
            
            enableNextButton()
        
        
        
        case .nonworkSleep, .nonworkSleep2:
            
            guard getAnswerFor(question: question) == nil else {return}
                    
            input.setValue(AnyResponse(type: .time, value: availabilityEndStr))
            
            enableNextButton()
        
        default:
            return
        }
    }
    
    
    private func getAnswerFor(question:WakeSurveyQuestion) -> String? {
        let question = question.rawValue
        
        guard let answer = Arc.shared.surveyController.getResponse(forQuestion: question, fromSurveyResponse: surveyId) else {
            return nil
        }
        
        guard let value = answer.value as? String else {return nil}
        
        return value
    }
}
