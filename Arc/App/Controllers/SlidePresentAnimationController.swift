//
//  SlidePresentAnimationController.swift
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

import Foundation
import UIKit

public extension UIWindow {
	
	/// Transition Options
    struct TransitionOptions {
		
		/// Curve of animation
		///
		/// - linear: linear
		/// - easeIn: ease in
		/// - easeOut: ease out
		/// - easeInOut: ease in - ease out
		public enum Curve {
			case linear
			case easeIn
			case easeOut
			case easeInOut
			
			/// Return the media timing function associated with curve
			internal var function: CAMediaTimingFunction {
				let key: String!
				switch self {
				case .linear:		key = CAMediaTimingFunctionName.linear.rawValue
				case .easeIn:		key = CAMediaTimingFunctionName.easeIn.rawValue
				case .easeOut:		key = CAMediaTimingFunctionName.easeOut.rawValue
				case .easeInOut:	key = CAMediaTimingFunctionName.easeInEaseOut.rawValue
				}
				return CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: key!))
			}
		}
		
		/// Direction of the animation
		///
		/// - fade: fade to new controller
		/// - toTop: slide from bottom to top
		/// - toBottom: slide from top to bottom
		/// - toLeft: screen appears from the left
		/// - toRight: screen appears from right
		public enum Direction {
			case fade
			case toTop
			case toBottom
			case toLeft
			case toRight
			
			/// Return the associated transition
			///
			/// - Returns: transition
			internal func transition() -> CATransition {
				let transition = CATransition()
				transition.type = CATransitionType.push
				switch self {
				case .fade:
					transition.type = CATransitionType.fade
					transition.subtype = nil
				case .toLeft:
					transition.subtype = CATransitionSubtype.fromLeft
				case .toRight:
					transition.subtype = CATransitionSubtype.fromRight
				case .toTop:
					transition.subtype = CATransitionSubtype.fromTop
				case .toBottom:
					transition.subtype = CATransitionSubtype.fromBottom
				}
				return transition
			}
		}
		
		/// Background of the transition
		///
		/// - solidColor: solid color
		/// - customView: custom view
		public enum Background {
			case solidColor(_: UIColor)
			case customView(_: UIView)
		}
		
		/// Duration of the animation (default is 0.20s)
		public var duration: TimeInterval = 0.20
		
		/// Direction of the transition (default is `toRight`)
		public var direction: TransitionOptions.Direction = .toRight
		
		/// Style of the transition (default is `linear`)
		public var style: TransitionOptions.Curve = .easeInOut
		
		/// Background of the transition (default is `nil`)
		public var background: TransitionOptions.Background? = nil
		
		/// Initialize a new options object with given direction and curve
		///
		/// - Parameters:
		///   - direction: direction
		///   - style: style
		public init(direction: TransitionOptions.Direction = .toRight, style: TransitionOptions.Curve = .linear) {
			self.direction = direction
			self.style = style
		}
		
		public init() { }
		
		/// Return the animation to perform for given options object
		internal var animation: CATransition {
			let transition = self.direction.transition()
			transition.duration = self.duration
			transition.timingFunction = self.style.function
			return transition
		}
	}
	
	
	/// Change the root view controller of the window
	///
	/// - Parameters:
	///   - controller: controller to set
	///   - options: options of the transition
    func setRootViewController(_ controller: UIViewController, options: TransitionOptions = TransitionOptions()) {
		
		var transitionWnd: UIWindow? = nil
		if let background = options.background {
			transitionWnd = UIWindow(frame: UIScreen.main.bounds)
			switch background {
			case .customView(let view):
				transitionWnd?.rootViewController = UIViewController.newController(withView: view, frame: transitionWnd!.bounds)
			case .solidColor(let color):
				transitionWnd?.backgroundColor = color
			}
			transitionWnd?.makeKeyAndVisible()
		}
		
		// Make animation
		self.layer.add(options.animation, forKey: kCATransition)
		self.rootViewController = controller
		if isKeyWindow == false {
			self.makeKeyAndVisible()
		}
		
		if let wnd = transitionWnd {
			DispatchQueue.main.asyncAfter(deadline: (.now() + 1 + options.duration), execute: {
				wnd.removeFromSuperview()
			})
		}
	}
    func getBackgroundColor() -> UIColor{
        guard let rootVC = rootViewController else {
            return .white;
        }
        var color = UIColor.white;
        if let vc = rootVC as? UINavigationController,
           let c = vc.topViewController?.view.backgroundColor{
            color = c;
        }
        else if let vc = rootVC as? UITabBarController{
            if let innerVC = vc.selectedViewController as? UINavigationController,
               let c = innerVC.topViewController?.view.backgroundColor{
                color = c;
            } else {
                color = vc.selectedViewController?.view?.backgroundColor ?? .white;
            }
        }
        return color
    }
}

internal extension UIViewController {
	
	/// Create a new empty controller instance with given view
	///
	/// - Parameters:
	///   - view: view
	///   - frame: frame
	/// - Returns: instance
	static func newController(withView view: UIView, frame: CGRect) -> UIViewController {
		view.frame = frame
		let controller = UIViewController()
		controller.view = view
		return controller
	}
	
}
