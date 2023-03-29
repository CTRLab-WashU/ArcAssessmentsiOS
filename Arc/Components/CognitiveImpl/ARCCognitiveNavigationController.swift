//
//  ARCNavigationController.swift
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
import UIKit

public protocol ARCCognitiveHomeViewControllerDelegate: Any {
    func homeViewController() -> UIViewController
}

open class ARCCognitiveNavigationController : AppNavigationController {
    
    public var runningTestStates: [ARCCognitiveState] = []
    public var stateIdx = -1
    
    public var vcDelegate: ARCCognitiveHomeViewControllerDelegate? = nil
    
    public func startTest(stateList: [ARCCognitiveState], info: ArcAssessmentSupplementalInfo? = nil) -> UIViewController? {
        ACState.totalTestCountInSession = 1
        ACState.testTaken = 0
        self.runningTestStates = stateList
        self.stateIdx = 0
        Arc.shared.appController.startNewTest(info: info)
        return stateList[self.stateIdx].viewForState()
    }
    
    public func endTest() {
        self.runningTestStates = []
        self.stateIdx = -1
        self.currentWindow()?.rootViewController?.dismiss(animated: true)
    }
    
    public func previousState() -> State? {
        let prevIdx = self.stateIdx - 1
        if (prevIdx < 0) {
            return nil
        }
        self.stateIdx = prevIdx
        return self.runningTestStates[self.stateIdx]
    }

    public func nextAvailableState(runPeriodicBackgroundTask: Bool) -> State {
        return nextAvailableSurveyState()!
    }
    
    public func nextAvailableSurveyState() -> State? {
        // Allow flexibility of setting states in custom order for tests
        if self.runningTestStates.count > 0 {
            let nextIdx = self.stateIdx + 1
            if (nextIdx >= self.runningTestStates.count) {
                return nil
            }
            self.stateIdx = nextIdx                
            return self.runningTestStates[self.stateIdx]
        }

        return nil
    }
    
    public func viewForState(state:State) -> UIViewController {
        return state.viewForState()
    }
        
    public func navigate(state:State, direction: UIWindow.TransitionOptions.Direction = .toRight) {
        navigate(vc: viewForState(state: state), direction: direction)
    }
    
    public func currentWindow() -> UIWindow? {
        guard let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else {
            
            debugPrint("Could not find forground key window to show screen")
            return nil
        }
        return window
    }
    
    public func currentViewController() -> UIViewController? {
        guard let window = self.currentWindow() else {
            return nil
        }
        
        var currentVc = window.rootViewController
        if window.rootViewController?.presentedViewController != nil {
            currentVc = window.rootViewController?.presentedViewController
        }
        if currentVc == nil {
            window.makeKeyAndVisible()
            return nil
        }
        
        return currentVc
    }
    
    public func navigate(vc: UIViewController, direction: UIWindow.TransitionOptions.Direction, duration: Double) {
        guard let window = self.currentWindow() else {
            return
        }
        guard let _ = self.currentViewController() else {
            window.makeKeyAndVisible()
            return
        }
                
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromRight
        window.layer.add(transition, forKey: nil)
        if let current = window.rootViewController?.presentedViewController {
            current.dismiss(animated: false, completion: {
                vc.modalPresentationStyle = .fullScreen
                window.rootViewController?.present(vc, animated: false, completion: nil)
            })
        } else {
            vc.modalPresentationStyle = .fullScreen
            window.rootViewController?.present(vc, animated: false, completion: nil)
        }
    }
    
    public func navigate(vc: UIViewController, direction: UIWindow.TransitionOptions.Direction) {
        navigate(vc: vc, direction: direction, duration: 0.5)
    }
    
    public func defaultHelpState() -> UIViewController {
        return UIViewController() // not needed in this app
    }
    
    public func defaultAbout() -> State {
        return ARCCognitiveState.home // not needed in this app
    }
    
    public func defaultContact() -> State {
        return ARCCognitiveState.home // not needed in this app
    }
    
    public func defaultPrivacy() {
        // not needed in this app
    }
    
    public func defaultState() -> State {
        return ARCCognitiveState.home // not needed in this app
    }
    
    public func shouldNavigate(to state: State) -> Bool {
        return true
    }
}
