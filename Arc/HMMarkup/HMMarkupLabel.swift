//
//  HMMarkupLabel.swift
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

@IBDesignable open class HMMarkupLabel: UILabel {
    @IBInspectable public var translationKey:String?
    
    open var renderer:HMMarkupRenderer!
    @IBInspectable public var spacing:CGFloat = 5
    
    open var template:Dictionary<String, String> = [:]
    
    override open var text: String? {
        didSet {
            markupText()
        }
    }
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        //markupText()
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        markupText()
    }
    
    public func markupText() {
        var text = self.text ?? ""
        if let config = HMMarkupRenderer.config, config.shouldTranslate, let key = translationKey {
            text = config.translation?[key] ?? text
        }
        renderer = HMMarkupRenderer(baseFont: self.font)
        //TODO:merge this with the attributes from the new render
        //var prevAttributes = self.attributedText?.attributes(at: 0, effectiveRange: nil)

        let attributedString = NSMutableAttributedString(attributedString: renderer.render(text: text, template: self.template))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = self.textAlignment
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : self.textColor!], range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
}
@IBDesignable open class HMMarkupTextView: UITextView {
    
    open var renderer:HMMarkupRenderer!
    @IBInspectable public var spacing:CGFloat = 5.5
    private var _originalText:String?
    override open var text: String? {
        didSet {
            markupText()
        }
    }
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        //markupText()
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
       
        
        //markupText()
    }
    
    public func markupText() {
        let text = self.text ?? ""
        renderer = HMMarkupRenderer(baseFont: self.font ?? UIFont.systemFont(ofSize: 18.0))
        let attributedString = NSMutableAttributedString(attributedString: renderer.render(text: text))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = self.textAlignment
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : self.textColor!], range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
    public func setLink(url:String, range:ClosedRange<Int>) {
        guard let url = URL(string: url) else {
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = self.textAlignment
        
        let r = NSMakeRange(range.lowerBound, range.upperBound - range.lowerBound)
        
        if let string = attributedText.mutableCopy() as? NSMutableAttributedString {
            string.setAttributes([.link: url,
                                  NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                  NSAttributedString.Key.font : self.font?.boldFont() ?? UIFont.systemFont(ofSize: 18.0)
                ], range: r)
            attributedText = string
            self.linkTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
                
            ]
        }
        
    }
    
    
}
