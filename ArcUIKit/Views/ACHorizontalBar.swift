//
//  ACHorizontalSeparator.swift
//  ArcUIKit
//
//  Created by Philip Hayes on 7/1/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import UIKit

public class ACHorizontalBar: UIView {
	var config : Drawing.HorizontalBar
	var animation:Animate = Animate()
		.duration(0.4)
		.delay(0.2)
		.curve(.easeOut)
	
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
						return
					}
					weakSelf.config.progress = Math.lerp(
						a: old,
						b: newValue,
						t: CGFloat(t))
				
					weakSelf.setNeedsDisplay()
				
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
		}
	}
	init() {
		config = Drawing.HorizontalBar(
			rect: .zero,
			bounds:	.zero,
			cornerRadius: 0,
			primaryColor: UIColor(red:0.97,
								  green:0.75,
								  blue:0.08,
								  alpha:1),
			progress: 1.0)
		super.init(frame: .zero)
		config.rect = frame
		config.bounds = bounds
		backgroundColor = .clear
		
	}
	
	required init?(coder: NSCoder) {
		config = Drawing.HorizontalBar(
			rect: .zero,
			bounds:	.zero,
			cornerRadius: 0,
			primaryColor: UIColor(red:0.97,
								  green:0.75,
								  blue:0.08,
								  alpha:1),
			progress: 1.0)
		super.init(coder: coder)
		config.rect = frame
		config.bounds = bounds
		backgroundColor = .clear

	}
	/*
     Only override draw() if you perform custom drawing.
     An empty implementation adversely affects performance during animation.*/
    override public func draw(_ rect: CGRect) {
		config.rect = rect
		config.bounds = bounds
		print(config.progress)
		config.draw()
		
    }
	

}
extension UIView {
	@discardableResult
	public func acHorizontalBar(apply closure: (ACHorizontalBar) -> Void) -> ACHorizontalBar {
		custom(ACHorizontalBar(), apply: closure)
	}
}
