//
//  GoalView.swift
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

public class GoalView: UIView {
	weak public var contentStack:UIStackView!
	weak var goalRewardView:GoalRewardView!
	weak var goalTitleLabel:ACLabel!
	weak var doneView:UIView!
	weak var doneLabel:ACLabel!
	weak var goalBodyLabel:ACLabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	public init() {
		super.init(frame: .zero)
		build()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		build()
	}
	public func build() {
		backgroundColor = .white
		layer.cornerRadius = 4.0
		clipsToBounds = true
		stack { [unowned self] in
			$0.axis = .vertical
			$0.attachTo(view: $0.superview)
			
			//Header Bar and title
			$0.view {
				$0.layout {
					$0.height == 54 ~ 999
				}
				$0.backgroundColor = ACColor.goalHeader

				$0.stack {
					$0.axis = .vertical
					$0.alignment = .leading
					$0.attachTo(view: $0.superview)
					$0.isLayoutMarginsRelativeArrangement = true
					$0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

					$0.stack {
						$0.isLayoutMarginsRelativeArrangement = true
						$0.axis = .horizontal
						
						$0.spacing = 8
						$0.alignment = .center
						$0.distribution = .equalCentering
						self.goalTitleLabel = $0.acLabel {
							Roboto.Style.goalHeading($0, color: ACColor.badgeText)
							$0.numberOfLines = 1
						}
						self.doneView = $0.view{
							$0.backgroundColor = ACColor.badgeBackground
							$0.layer.cornerRadius = 4
							$0.clipsToBounds = true
							$0.isHidden = true

							self.doneLabel = $0.acLabel {
								Roboto.Style.goalReward($0, color:ACColor.badgeText)
								$0.text = "".localized(ACTranslationKey.status_done)
								$0.setContentCompressionResistancePriority(.required, for: .horizontal)
							}
							self.doneLabel.attachTo(view: $0, margins: UIEdgeInsets(top: 3,
										left: 10,
										bottom: 3,
										right: 10))
							
									
						}
						$0.view {
							$0.backgroundColor = .clear
						}
	//
					}
				}
				
			}
			//Custom content body, white background
			$0.stack {
				$0.axis = .vertical
				$0.isLayoutMarginsRelativeArrangement = true
				$0.layoutMargins = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
				
                let v = $0.view {
					$0.backgroundColor = .white
					
					
					self.contentStack = $0.stack {
						$0.axis = .vertical
						$0.spacing = 20
						$0.attachTo(view: $0.superview)
					}
					
					
					
					
				}
				$0.setCustomSpacing(25, after: v)
				self.goalRewardView = $0.goalReward {
					
					$0.isUnlocked = false
					$0.set(text: "$0.00 Bonus".localized(ACTranslationKey.earnings_bonus_incomplete))
					
				}
			}
			
		}
		self.buildContent(view: self.contentStack)

	}
	public func clear() {
		
	}
	public func set(titleText:String) {
		 goalTitleLabel.text = titleText
	}
	public func set(bodyText:String){
		goalBodyLabel.text = bodyText
	}
	public func set(isUnlocked:Bool, date:String? = nil) {
		doneView.isHidden = !isUnlocked
		if let date = date {
			doneLabel.text = ""
				.localized(ACTranslationKey.status_done_withdate)
			.replacingOccurrences(of: "{DATE}", with: date)
		} else {
			doneLabel.text = ""
			.localized(ACTranslationKey.status_done)
		}
		goalRewardView.isUnlocked = isUnlocked
	}
	public func set(goalRewardText:String) {
		goalRewardView.set(text: goalRewardText)
	}
	func buildContent(view:UIView) {
		
	}
	

}

extension UIView {
	@discardableResult
	public func goalView(apply closure: (GoalView) -> Void) -> GoalView {
		return custom(GoalView(), apply: closure)
	}
}
