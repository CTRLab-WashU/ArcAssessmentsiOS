//
//  WeekStepperView.swift
//  Arc
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

public class ACWeekStepperView : StepperProgressView {
	
	private var itemStack:UIStackView!
	private var target:UIView!
	init() {
		super.init(frame: .zero)
		config.foregroundColor = #colorLiteral(red: 0, green: 0.3729999959, blue: 0.5220000148, alpha: 1)
		config.outlineColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1)
		
		layout {
			$0.height == 50 ~ 999
		}
		let stepper = self
		itemStack = stack {
			$0.layout {
				
				$0.leading == stepper.leadingAnchor
				$0.top == stepper.topAnchor
				$0.trailing == stepper.trailingAnchor
				$0.bottom == stepper.bottomAnchor
			}
			$0.axis = .horizontal
			$0.distribution = .equalSpacing
			$0.isLayoutMarginsRelativeArrangement = true
			$0.layoutMargins = .init(top: 0, left: 7, bottom: 0, right: 7)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func set(step:Int, of totalValues:[String]) {
		assert(totalValues.count != 0, "total values cannot be empty.")
		assert(step >= 0, "step cannot be negative.")
		assert(step < totalValues.count, "step cannot exceed totalValues - 1.")

		itemStack.removeSubviews()
		for i in 0 ..< totalValues.count {
			
			let item = itemStack.acLabel {
				if i <= step {
					Roboto.Style.bodyBold($0, color: .white)

				} else {
					Roboto.Style.bodyBold($0)

				}
				
				$0.textAlignment = .center
				$0.text = "\(totalValues[i])"
			}
			if i == step {
				target = item
			}
			
		}
		

	
	}
	public override func draw(_ rect: CGRect) {
		
		
		pos = target.center.x
		super.draw(rect)

	}
	
}

extension UIView {
	
	@discardableResult
	public func weekStepperProgress(apply closure: (ACWeekStepperView) -> Void) -> ACWeekStepperView {
		return custom(ACWeekStepperView(), apply: closure)
	}
	
}
