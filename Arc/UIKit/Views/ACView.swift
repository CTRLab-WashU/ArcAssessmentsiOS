//
//  ACView.swift
//  ArcUIKit
//
//  Created by Philip Hayes on 6/5/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable open class ACView: UIView  {
	
    @IBInspectable public var borderColor:UIColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderThickness:CGFloat = 0.0 {
        didSet {
            print(borderThickness)
            layer.borderWidth = borderThickness
        }
    }
	@IBInspectable public var cornerRadius:CGFloat = 0.0 {
		didSet {
			layer.cornerRadius = cornerRadius
		}
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = cornerRadius
		layer.borderColor = borderColor.cgColor
		layer.borderWidth = borderThickness
	}
	override open func awakeFromNib() {
		super.awakeFromNib()
		layer.cornerRadius = cornerRadius
		layer.borderColor = borderColor.cgColor
		layer.borderWidth = borderThickness
	}
	
	override open func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		layer.cornerRadius = cornerRadius
		layer.borderColor = borderColor.cgColor
		layer.borderWidth = borderThickness

	}
	
}
