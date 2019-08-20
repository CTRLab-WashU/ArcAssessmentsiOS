//
//  PostTestEarningsView.swift
//  Arc
//
//  Created by Philip Hayes on 8/19/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import ArcUIKit

public class ACPostTestEarningsView : UIView {
	public override init(frame: CGRect) {
		super.init(frame:.zero)
		build()
	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		build()
	}
	
	func build() {
		scroll {
			$0.attachTo(view: $0.superview)
			stack {
				$0.safeAttachTo(view: $0.superview)
				$0.layout {
					$0.width == self.widthAnchor ~ 999
				}
				
			}
		}
		
		view {
			$0.layout {
				$0.bottom == self.bottomAnchor ~ 999
				$0.trailing == self.trailingAnchor ~ 999
				$0.leading == self.leadingAnchor ~ 999
				$0.height == 96 ~ 999
			}
			bottomGradient(view: $0)
			$0.acButton {
				$0.attachTo(view: $0.superview)
				$0.setTitle("".localized(ACTranslationKey.button_next), for: .normal)
			}
		}
	}
	
	func bottomGradient(view:UIView){
		let gradient = CAGradientLayer()
//		gradient.frame = CGRect(x: 0, y: 0, width: 320, height: 96)
		gradient.colors = [	UIColor(red:0.04, green:0.12, blue:0.33, alpha:0).cgColor,	UIColor(red:0.04, green:0.12, blue:0.33, alpha:1).cgColor]
		gradient.locations = [0, 1]
		gradient.startPoint = CGPoint(x: 0.5, y: 0)
		gradient.endPoint = CGPoint(x: 0.5, y: 0.51)
		view.layer.addSublayer(gradient)
	}
}