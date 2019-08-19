//
//  GoalBackgroundView.swift
//  Arc
//
//  Created by Philip Hayes on 8/15/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import UIKit
import ArcUIKit
public class GoalBackgroundView: UIView {
	public var config:Drawing.BadgeGradient = Drawing.BadgeGradient()
	init() {
		super.init(frame: .zero)
		backgroundColor = .clear

	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		backgroundColor = .clear

	}
	override public func draw(_ rect: CGRect) {
		
			config.draw(rect)
    }

}
extension UIView {
	@discardableResult
	public func goalBackgroundView(apply closure: (GoalBackgroundView) -> Void) -> GoalBackgroundView {
		return custom(GoalBackgroundView(), apply: closure)
	}
}
