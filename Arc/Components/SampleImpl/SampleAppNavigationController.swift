//
// SampleAppNavigationController.swift
// Arc
//
// Copyright (c) 2023 Washington University in St. Louis
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
import UIKit

open class SampleAppNavigationController : AppNavigationController {
    
    public var states: [SampleAppState] = []
    public var stateIdx = 0
    
    public func getCognitiveAssessmentIndex(state: SampleAppState) -> Int {
        return self.states.filter({ $0.isCognitiveAssessment() }).firstIndex(of: state) ?? 0
    }
    
    public func startTest(stateList: [SampleAppState], info: ArcAssessmentSupplementalInfo? = nil) -> UIViewController? {
        
        ACState.testTaken = 0
        self.states = stateList
        self.stateIdx = 0
        
        Arc.shared.appController.startNewTest(info: info)
        
        guard let firstState = stateList.first else {
            return nil
        }
        
        return self.viewForState(state: firstState)
    }
    
    public func defaultHelpState() -> UIViewController {
        return UIViewController()
    }
    
    public func previousState() -> State? {
        let prevIdx = self.stateIdx - 1
        if (prevIdx < 0) {
            return nil
        }
        self.stateIdx = prevIdx
        return self.states[self.stateIdx]
    }
    
    public func defaultState() -> State {
        return SampleAppState.all
    }

    public func defaultAbout() -> State {
        return SampleAppState.all
    }
    
    public func defaultContact() -> State {
        return SampleAppState.all
    }
    
    public func defaultPrivacy() {
        // no-op
    }

    public func nextAvailableState(runPeriodicBackgroundTask: Bool) -> State {
        return nextAvailableSurveyState()!
    }
    
    public func nextAvailableSurveyState() -> State? {
        let nextIdx = self.stateIdx + 1
        if (nextIdx >= self.states.count) {
            return nil
        }
        self.stateIdx = nextIdx
        return self.states[self.stateIdx]
    }
    
    public func viewForState(state:State) -> UIViewController {
        return state.viewForState()
    }
        
    public func navigate(state:State, direction: UIWindow.TransitionOptions.Direction = .toRight) {
        navigate(vc: viewForState(state: state), direction: direction)
    }
    
    public func navigate(vc: UIViewController, direction: UIWindow.TransitionOptions.Direction, duration: Double) {
        guard let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else {
            
            debugPrint("Could not find forground key window to show screen")
            return
        }
    
        guard let currentVc = window.rootViewController?.presentedViewController else {
            window.makeKeyAndVisible()
            return
        }
        
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromRight
        window.layer.add(transition, forKey: nil)
        window.rootViewController?.dismiss(animated: false, completion: {
            vc.modalPresentationStyle = .fullScreen
            window.rootViewController?.present(vc, animated: false, completion: nil)
        })
    }
    
    public func navigate(vc: UIViewController, direction: UIWindow.TransitionOptions.Direction) {
        navigate(vc: vc, direction: direction, duration: 0.5)
    }
    
    public func shouldNavigate(to state: State) -> Bool {
        return true
    }
}

extension CATransition {

    //New viewController will appear from bottom of screen.
    func segueFromBottom() -> CATransition {
        self.duration = 0.375 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromTop
        return self
    }
    
    //New viewController will appear from top of screen.
    func segueFromTop() -> CATransition {
        self.duration = 0.375 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromBottom
        return self
    }
    
    //New viewController will appear from left side of screen.
    func segueFromLeft() -> CATransition {
        self.duration = 0.1 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromLeft
        return self
    }
    
    //New viewController will pop from right side of screen.
    func popFromRight() -> CATransition {
        self.duration = 0.1 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.reveal
        self.subtype = CATransitionSubtype.fromRight
        return self
    }
    
    //New viewController will appear from left side of screen.
    func popFromLeft() -> CATransition {
        self.duration = 0.1 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.reveal
        self.subtype = CATransitionSubtype.fromLeft
        return self
    }
}
