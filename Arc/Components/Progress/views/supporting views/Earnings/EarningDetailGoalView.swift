//
//  EarningDetailGoalView.swift
//  Arc
//
//  Created by Philip Hayes on 8/22/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import Foundation
import ArcUIKit
import UIKit

public class EarningsDetailGoalView : UIView {
	weak var bodyLabel:ACLabel!
	weak var valueLabel:ACLabel!
	init() {
		super.init(frame: .zero)
		build()
	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		build()
	}
	func build() {
		backgroundColor = .clear
		isOpaque = false
		stack { [unowned self] in
			$0.attachTo(view: $0.superview, margins: UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24))
			$0.distribution = .fill
			self.bodyLabel = $0.acLabel {
				Roboto.Style.body($0, color:.white)
				$0.textAlignment = .left
			}
			self.valueLabel =  $0.acLabel {
				Roboto.Style.body($0, color:.white)
				$0.textAlignment = .right
			}
		}
	}
	public func set(body:String) {
		bodyLabel.text = body
	}
	public func set(value:String) {
		valueLabel.text = value
	}
}

extension UIView {
	@discardableResult
	public func earningsDetailGoalView(apply closure: (EarningsDetailGoalView) -> Void) -> EarningsDetailGoalView {
		return custom(EarningsDetailGoalView(), apply: closure)
	}
}


