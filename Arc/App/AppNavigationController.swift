//
//  AppManager.swift
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
///Decides what state to put the application in based on available
///information

public protocol AppNavigationController {
	func defaultHelpState() -> UIViewController
    
    func defaultAbout() -> State
    
    func defaultContact() -> State
    
    func defaultPrivacy()

	///This function should ideally send you back home.
	func defaultState() -> State
	
	///The previous state
	func previousState() -> State?
	
	///This returns a view controller for an object that conforms to state
	func viewForState(state:State) -> UIViewController
	
	///Consume a state object and move to the desired location in the app
	func navigate(state:State, direction: UIWindow.TransitionOptions.Direction)
	
	///If a test session has begun what shall we do next?
	func nextAvailableSurveyState() -> State?
	
	///Just replace the current root view controller
	func navigate(vc:UIViewController, direction: UIWindow.TransitionOptions.Direction)
	
	///Just replace the current root view controller
	func navigate(vc:UIViewController, direction: UIWindow.TransitionOptions.Direction, duration:Double)
    
    /// To stop a navigation call from occuring, call this function
    func shouldNavigate(to state: State) -> Bool
}


open class BaseAppNavigationController : AppNavigationController {
    
	public func screenShotApp() -> [URL] {
		return []
	}
	
    public init() {
        
    }
	public func defaultHelpState() -> UIViewController {
		return ACState.home.viewForState()
	}
    
    public func defaultContact() -> State {
        return ACState.contact
    }
	
	private var _previousState:State?
	private var state:State = ACState.home
	public func previousState() -> State? {
		return _previousState
	}
	
	
	public func defaultState() -> State {
		return ACState.home
	}

    public func defaultAbout() -> State {
        return ACState.about
    }
    
    public func defaultPrivacy() {
        print("Must override this")
    }
	
	public func nextAvailableSurveyState() -> State? {
		return ACState.home

	}
	public func viewForState(state:State) -> UIViewController {
		
		self._previousState = self.state
		self.state = state
		let vc = state.viewForState()
		
		
		return vc
	}
	
	
	public func navigate(state:State, direction: UIWindow.TransitionOptions.Direction = .toRight) {
		navigate(vc: viewForState(state: state), direction: direction)
	}
	public func navigate(vc: UIViewController, direction: UIWindow.TransitionOptions.Direction, duration: Double) {
		guard let window = UIApplication.shared.keyWindow else {
			assertionFailure("No Keywindow")
			
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



