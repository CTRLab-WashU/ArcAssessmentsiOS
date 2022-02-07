//
//  GoalsGroup.swift
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

import Foundation
import UIKit


public class GoalsGroup : UIStackView {
	weak var fourofFourGoal:FourOfFourGoalView!
	weak var twoADayGoal:TwoADayGoalView!
	weak var totalSessionsGoal:TotalSessionGoalView!
	init() {
		super.init(frame:.zero)
	}
	
	required init(coder: NSCoder) {
		super.init(coder:coder)
	}
	func build() {
		
		backgroundColor = ACColor.primaryInfo
		stack {
			
			$0.attachTo(view: $0.superview)
			$0.axis = .vertical
			$0.alignment = .fill
			$0.spacing = 16
			$0.isLayoutMarginsRelativeArrangement = true
			$0.layoutMargins = UIEdgeInsets(top: 12, left: 8, bottom: 48, right: 8)
			
			
			self.fourofFourGoal = $0.fourOfFourGoalView {
				$0.set(titleText: "4 Out of 4".localized(ACTranslationKey.earnings_4of4_header))
				$0.set(isUnlocked: false)
				
			}
			
			//2 a day goal
			self.twoADayGoal = $0.twoADayGoalView {
				$0.set(titleText: "2-A-Day".localized(ACTranslationKey.earnings_2aday_header))
				$0.set(isUnlocked: false)
				
				
			}
			
			
			self.totalSessionsGoal = $0.totalSessionGoalView {
				$0.set(titleText: "21 Sessions".localized(ACTranslationKey.earnings_21tests_header))
				$0.set(isUnlocked: false)
				
			}
			
		}
		
	}
	
}
