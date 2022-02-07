//
//  UILabel+Extensions.swift
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
public extension UIFont {
	func family(_ family:String) -> UIFont {
		var attributes = fontDescriptor.fontAttributes
		attributes[.family] = family
		
		return UIFont(descriptor: UIFontDescriptor(fontAttributes: attributes), size:0)
	}
	func face(_ face:String) -> UIFont {
		var attributes = fontDescriptor.fontAttributes
		
		attributes[.face] = face
		
		return UIFont(descriptor: UIFontDescriptor(fontAttributes: attributes), size:0)
	}
    func boldFont() -> UIFont {
        return addingSymbolicTraits(.traitBold)
    }
	
    func italicFont() -> UIFont {
        return addingSymbolicTraits(.traitItalic)
    }
	
	func size(_ value:CGFloat) -> UIFont {
		var attributes = fontDescriptor.fontAttributes

		attributes[.size] = value
		
		return UIFont(descriptor: UIFontDescriptor(fontAttributes: attributes), size:value)
	}
	func size(_ value:Double) -> UIFont {
		return size(CGFloat(value))
	}
	func size(_ value:Int) -> UIFont {
		return size(CGFloat(value))
	}
	func addingSymbolicTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let newTraits = fontDescriptor.symbolicTraits.union(traits)
        guard let descriptor = fontDescriptor.withSymbolicTraits(newTraits) else {
			assertionFailure("Failed to add attribute to font!")
            return self
        }
        
        return UIFont(descriptor: descriptor, size: 0)
    }
}

public extension UILabel
{
	
    // Resizes font size so that single words won't wrap characters if they're too long to fit
    
    func resizeFontForSingleWords()
    {
        guard let currentFont = self.font else { return; }
        guard let currentText = self.text else { return; }
        
        var minFont = currentFont;
        let words = currentText.components(separatedBy: " ");
        let currentRect = self.frame;
        
        for w in words
        {
            var wRect = (w as NSString).boundingRect(with: currentRect.size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: minFont], context: nil);
            
            while wRect.width > currentRect.size.width
            {
                minFont = minFont.withSize(minFont.pointSize - 0.5);
                wRect = (w as NSString).boundingRect(with: currentRect.size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: minFont], context: nil);
            }
        }
        
        self.font = minFont;
    }
}
