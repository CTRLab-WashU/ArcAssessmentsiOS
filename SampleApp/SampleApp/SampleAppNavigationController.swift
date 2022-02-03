//
//  SampleAppNavigationController.swift
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

open class SampleAppNavigationController : AppNavigationController {
    
    public var states: [SampleAppState] = []
    public var stateIdx = 0
    
    public func startTest(stateList: [SampleAppState]) -> UIViewController? {
        self.states = stateList
        self.stateIdx = 0
        
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
        
        guard let _ = window.rootViewController else {
            window.rootViewController = vc
            window.makeKeyAndVisible()
            return
        }
        var options = UIWindow.TransitionOptions(direction: direction, style: .linear)
        options.duration = duration
        let view = UIView()
        view.backgroundColor = .white
        options.background = UIWindow.TransitionOptions.Background.customView(view)
        
        window.setRootViewController(vc, options:options)
    }
    
    public func navigate(vc: UIViewController, direction: UIWindow.TransitionOptions.Direction) {
        navigate(vc: vc, direction: direction, duration: 0.5)
    }
    
    public func shouldNavigate(to state: State) -> Bool {
        return true
    }
}
