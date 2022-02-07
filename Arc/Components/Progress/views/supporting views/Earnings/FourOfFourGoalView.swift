//
//  FourOfFourGoalView.swift
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

public class FourOfFourGoalView : GoalView {
	weak var progressGroup:ACCircularProgressGroupStackView!
	
	override func buildContent(view: UIView) {
		self.goalBodyLabel = view.acLabel {
			Roboto.Style.body($0)
			$0.text = "".localized(ACTranslationKey.earnings_4of4_body)
			.replacingOccurrences(of: "{AMOUNT}", with: "$1.00")
		}
		
		self.progressGroup = view.circularProgressGroup {
			$0.layout {
				$0.height == 56 ~ 999
			}
			$0.alignment = .center
			$0.config.strokeWidth = 4
			$0.config.size = 56
			$0.ellipseConfig.size = 56
			$0.checkConfig.size = 25
			$0.addProgressViews(count: 4)
			
		}
		set(goalRewardText: "$0.00 Bonus".localized(ACTranslationKey.earnings_bonus_incomplete)
		.replacingOccurrences(of: "{AMOUNT}", with: "$1.00"))
	}
	public func set(progress:Double, for index:Int) {
		progressGroup.set(progress: progress, for: index)
	}
}

extension UIView {
	@discardableResult
	public func fourOfFourGoalView(apply closure: (FourOfFourGoalView) -> Void) -> FourOfFourGoalView {
		return custom(FourOfFourGoalView(), apply: closure)
	}
}
