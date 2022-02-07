//
//  HMMarkupRenderer.swift
//  HMMarkup
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

import Foundation
import UIKit
import UIKit.UIFont
public typealias Font = UIFont

public final class HMMarkupRenderer {
    public struct Config {
        public var translation:Dictionary<String, String>?
        
        //Setting to false could result in seeing keys
        public var shouldTranslate:Bool = true
        public var translationIndex:Int = 1
        public init() {
            
        }
        
    }
    static public var config:Config?
	private let baseFont: Font
	
	public init(baseFont: Font) {
		self.baseFont = baseFont
	}
	
	public func render(text: String) -> NSAttributedString {
        var text = text
        if let config = HMMarkupRenderer.config, config.shouldTranslate {
            text = config.translation?[text] ?? text
        }
		let elements = HMMarkupParser.parse(text: text)
		let attributes = [NSAttributedString.Key.font: baseFont]
		
		return elements.map { $0.render(withAttributes: attributes) }.joined()
	}
	public func render(text: String, template:Dictionary<String, String>) -> NSAttributedString {
        var text = text
        if let config = HMMarkupRenderer.config, config.shouldTranslate {
           text = config.translation?[text] ?? text
        }
		for (key, value) in template {
			text = text.replacingOccurrences(of: "{\(key)}", with: value)
		}
		return render(text: text)
	}
}

public extension HMMarkupNode {
    public func render(withAttributes attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
		guard let currentFont = attributes[NSAttributedString.Key.font] as? Font else {
			fatalError("Missing font attribute in \(attributes)")
		}
		
		switch self {
		case .text(let text):
			return NSAttributedString(string: text, attributes: attributes)
			
		case .strong(let children):
			var newAttributes = attributes
			newAttributes[NSAttributedString.Key.font] = currentFont.boldFont()
			return children.map { $0.render(withAttributes: newAttributes) }.joined()
			
		case .emphasis(let children):
			var newAttributes = attributes
			newAttributes[NSAttributedString.Key.font] = currentFont.italicFont()
			return children.map { $0.render(withAttributes: newAttributes) }.joined()
			
		case .delete(let children):
			var newAttributes = attributes
			newAttributes[NSAttributedString.Key.strikethroughStyle] = NSUnderlineStyle.single.rawValue
			newAttributes[NSAttributedString.Key.baselineOffset] = 0
			return children.map { $0.render(withAttributes: newAttributes) }.joined()
		case .underline(let children):
			var newAttributes = attributes
			newAttributes[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
			newAttributes[NSAttributedString.Key.baselineOffset] = 0
			return children.map { $0.render(withAttributes: newAttributes) }.joined()
		}
	}
}

public extension Array where Element: NSAttributedString {
    public func joined() -> NSAttributedString {
		let result = NSMutableAttributedString()
		for element in self {
			result.append(element)
		}
		return result
	}
}

public extension UIFont {
	public func boldFont() -> UIFont? {
		return addingSymbolicTraits(.traitBold)
	}
	
    public func italicFont() -> UIFont? {
		return addingSymbolicTraits(.traitItalic)
	}
	
    public func addingSymbolicTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont? {
		let newTraits = fontDescriptor.symbolicTraits.union(traits)
		guard let descriptor = fontDescriptor.withSymbolicTraits(newTraits) else {
			return nil
		}
		
        return UIFont(descriptor: descriptor, size: self.pointSize)
	}
}
