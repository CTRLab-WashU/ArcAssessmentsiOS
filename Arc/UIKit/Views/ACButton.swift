//
//  ACButton.swift
//  ArcUIKit
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

@IBDesignable open class ACButton : HMMarkupButton {

    @IBInspectable public var cornerRadius:CGFloat = 24.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    open override var isSelected: Bool{
        didSet {
            self.setNeedsDisplay()

        }
    }
	
    @IBInspectable public var primaryColor:UIColor = ACColor.primary
    @IBInspectable public var secondaryColor:UIColor = ACColor.primaryGradient
	@IBInspectable public var topColor:UIColor = UIColor(white: 1.0, alpha: 0.25)
	@IBInspectable public var bottomColor:UIColor = UIColor(white: 0.0, alpha: 0.25)
	
	public init() {
		super.init(frame:.zero)
		Roboto.Style.bodyBold(titleLabel!)
		layout {
			$0.width >= 216 ~ 950
			$0.height >= 48 ~ 950
			$0.height == 48 ~ 250
			//$0.bottom >= self.bottomAnchor - 40 ~ 250
		}
	}
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
    open override func draw(_ rect: CGRect) {
		let config = Drawing.GradientButton(cornerRadius: cornerRadius,
											  primaryColor: primaryColor,
											  secondaryColor: secondaryColor,
											  topShadowColor: topColor,
											  bottomShadowColor: bottomColor,
											  isSelected: isSelected,
											  isEnabled: isEnabled)
        config.draw(rect)
    }
    override open func setup(isSelected:Bool){
        super.setup(isSelected:isSelected)
//        tintColor = .clear
        imageView?.layer.zPosition = 1
        
        if isEnabled {
            self.alpha = 1.0
        } else {
            self.alpha = 0.5
        }
        layer.cornerRadius = cornerRadius
        self.setNeedsDisplay()

      
        
    }
    
    open override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        

    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isSelected = true

    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isSelected = false


    }
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isSelected = false


    }
}

extension UIView {
	
	@discardableResult
	public func acButton(apply closure: (ACButton) -> Void) -> ACButton {
		return custom(ACButton(), apply: closure)
	}
	
}
