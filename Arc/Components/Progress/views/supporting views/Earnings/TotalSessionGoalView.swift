//
//  TotalSessionGoalView.swift
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

public class TotalSessionGoalView : GoalView {
	var current:Double = 0
	var total:Double = 21

	var progress:CGFloat {
		let value = max(min(total, current), 0.0)

		return CGFloat(value/total)
	}

	weak public var countLabel:ACLabel!
	weak var stepperProgressBar:StepperProgressView!
	
	override func buildContent(view: UIView) {
		self.goalBodyLabel = view.acLabel {
			Roboto.Style.body($0)
			$0.text = "".localized(ACTranslationKey.earnings_21tests_body)
			.replacingOccurrences(of: "{AMOUNT}", with: "$5.00")
		}
		view.stepperProgress { [unowned self] in
			$0.layout {
				$0.height == 36 ~ 999
			}
			$0.config.outlineColor = .clear
			$0.config.barWidth = 12
			$0.config.foregroundColor = ACColor.highlight
			$0.progress = 1.0
			self.stepperProgressBar = $0.stepperProgress {
				$0.attachTo(view: $0.superview)
				$0.config.outlineColor = .clear
				
				$0.config.barWidth = 12
				$0.progress = 0
				$0.config.foregroundColor = ACColor.primaryInfo
				self.countLabel = $0.endRectView.acLabel {
					$0.attachTo(view: $0.superview)
					
					$0.text = "0"
					$0.textAlignment = .center
					Roboto.Style.body($0, color:.white)
				}
			}
			
		}
		set(goalRewardText: "$0.00 Bonus".localized(ACTranslationKey.earnings_bonus_incomplete)
		.replacingOccurrences(of: "{AMOUNT}", with: "$5.00"))
	}
	
	public func set(current:Int) {
        let value = max(min(total, Double(current)), 0.0)
		self.current = value
		self.countLabel.text = "*\(Int(value))*"
		self.stepperProgressBar.progress = self.progress
	
	}
	public func set(total:Double) {
		self.total = total
		self.stepperProgressBar.progress = self.progress

	}
}

extension UIView {
	@discardableResult
	public func totalSessionGoalView(apply closure: (TotalSessionGoalView) -> Void) -> TotalSessionGoalView {
		return custom(TotalSessionGoalView(), apply: closure)
	}
}
