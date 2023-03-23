//
//  PrimaryButton.swift
// Arc
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

open class PrimaryButton : UIButton {
	@IBInspectable var primaryColor:UIColor = ACColor.primary
	@IBInspectable var secondaryColor:UIColor = ACColor.primaryGradient
	var gradient:CAGradientLayer?
    override open func awakeFromNib() {
		super.awakeFromNib()
		setup(isSelected: false)        
	}
	
	override open func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setup(isSelected: false)
	}
	
	
	override open var isHighlighted: Bool {
		didSet {
			setup(isSelected: isHighlighted)
		}
	}
	override open var isEnabled: Bool {
		didSet {
			if !isEnabled {
				setup(isSelected: false)

			} else {
				setup(isSelected: isHighlighted)

			}
		}
	}
	override open var intrinsicContentSize: CGSize {
		return CGSize(width: 216, height: 48)
	}
	override open func layoutIfNeeded() {
		super.layoutIfNeeded()
		
	}
	override open func layoutSubviews() {
		super.layoutSubviews()
		setup(isSelected: isHighlighted)
	}
	func setup(isSelected:Bool){
		CATransaction.begin()
		CATransaction.setAnimationDuration(0.03)
		layer.cornerRadius = 24
		layer.shadowOffset = CGSize(width: 0, height: 1)
		layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
		layer.shadowOpacity =  1
		layer.shadowRadius = (!isSelected) ? 2 : 0
		let gradient = self.gradient ?? CAGradientLayer()
		gradient.frame = CGRect(x: 0, y: 0, width: 216, height: 48)
		gradient.colors = (!isSelected && isEnabled) ? [secondaryColor.cgColor,
										 primaryColor.cgColor] : [primaryColor.cgColor,
																				 primaryColor.cgColor]
		
		if isEnabled {
			self.alpha = 1.0
		} else {
			self.alpha = 0.5
		}
		
		gradient.locations = [0, 1]
		gradient.startPoint = CGPoint(x: 0.5, y: 0)
		gradient.endPoint = CGPoint(x: 0.5, y: 1)
		gradient.cornerRadius = 24
		if gradient.superlayer == nil {
			self.gradient = gradient
			layer.addSublayer(gradient)
		}
		CATransaction.commit()
	}
}
