//
//  ACHorizontalSeparator.swift
//  ArcUIKit
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

public class ACHorizontalBar: UIView {
	public var config : Drawing.HorizontalBar
	public var animation:Animate = Animate()
		.duration(0.4)
		.delay(0)
		.curve(.none)
	
	public var relativeWidth : CGFloat {
		
		
		get {
			return config.progress
		}
		set {
			if window != nil {
				animation.stop()
				let old = config.progress
				animation.run {[weak self] t in
					guard let weakSelf = self else {
					
						return false
					}
					guard weakSelf.window != nil else {
						return false
					}
					weakSelf.config.progress = Math.lerp(
						a: old,
						b: newValue,
						t: CGFloat(t))
				
					weakSelf.setNeedsDisplay()
					return true
				}
			
			} else {
				config.progress = newValue
				setNeedsDisplay()
			}
		}
	}
	public var color : UIColor? {
		get {
			return config.primaryColor
		}
		set {
			config.primaryColor = newValue
			setNeedsDisplay()
		}
	}
	
	public var cornerRadius:CGFloat {
		set {
			config.cornerRadius = newValue
			setNeedsDisplay()
		}
		get {
			return config.cornerRadius
		}
	}
	init() {
		config = Drawing.HorizontalBar(
			cornerRadius: 0,
			primaryColor: UIColor(red:0.97,
								  green:0.75,
								  blue:0.08,
								  alpha:1),
			progress: 1.0)
		super.init(frame: .zero)
		backgroundColor = .clear
		
	}
	
	required init?(coder: NSCoder) {
		config = Drawing.HorizontalBar(
			
			cornerRadius: 0,
			primaryColor: UIColor(red:0.97,
								  green:0.75,
								  blue:0.08,
								  alpha:1),
			progress: 1.0)
		super.init(coder: coder)
		backgroundColor = .clear

	}
	/*
     Only override draw() if you perform custom drawing.
     An empty implementation adversely affects performance during animation.*/
    override public func draw(_ rect: CGRect) {
		config.draw(rect)
		
    }
	

}
extension UIView {
	@discardableResult
	public func acHorizontalBar(apply closure: (ACHorizontalBar) -> Void) -> ACHorizontalBar {
		return custom(ACHorizontalBar(), apply: closure)
	}
}
