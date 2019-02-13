//
//  HMMarkupLabel.swift
//  mHealth
//
//  Created by Matt Gannon on 11/16/18.
//  Copyright © 2018 healthyMedium. All rights reserved.
//

import UIKit

@IBDesignable open class HMMarkupLabel: UILabel {
    open var renderer:HMMarkupRenderer!
    @IBInspectable var spacing:CGFloat = 1.33
    
    override open var text: String? {
        didSet {
            markupText()
        }
    }
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        markupText()
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        markupText()
    }
    
    public func markupText() {
        let text = self.text ?? ""
        renderer = HMMarkupRenderer(baseFont: self.font)
        let attributedString = NSMutableAttributedString(attributedString: renderer.render(text: text))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = self.textAlignment
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttributes([.foregroundColor : self.textColor], range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
}
@IBDesignable open class HMMarkupTextView: UITextView {
    
    open var renderer:HMMarkupRenderer!
    @IBInspectable var spacing:CGFloat = 1.33
    
    override open var text: String? {
        didSet {
            markupText()
        }
    }
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        markupText()
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        markupText()
    }
    
    public func markupText() {
        let text = self.text ?? ""
        renderer = HMMarkupRenderer(baseFont: self.font ?? UIFont.systemFont(ofSize: 18.0))
        let attributedString = NSMutableAttributedString(attributedString: renderer.render(text: text))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = self.textAlignment
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttributes([.foregroundColor : self.textColor], range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
}
