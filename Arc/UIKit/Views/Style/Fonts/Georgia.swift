//
//  Fonts.swift
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

public struct Georgia {
    
	static public let family = "Georgia"
	public struct Face {
		static public let blackItalic = "BlackItalic"
	}
	public struct Font {
		static public let titleItalic = UIFont(name: "Georgia", size: 22.5)!
			.family(Georgia.family)
			.italicFont()
			.size(22.5)
		static public let bodyItalic = UIFont(name: "Georgia", size: 18)!
			.family(Georgia.family)
			.italicFont()
			.size(18)
		
		static public let largeTitle = UIFont(name: "Georgia", size: 42)!
			.family(Georgia.family)
			.size(42)
		static public let veryLargeTitle = UIFont(name: "Georgia", size: 42)!
			.family(Georgia.family)
			.size(96)

		
	}
	public struct Style {
		static public func title(_ label:UILabel, color:UIColor = #colorLiteral(red: 0.2349999994, green: 0.2349999994, blue: 0.2349999994, alpha: 1)) {
			label.font = Georgia.Font.titleItalic
			label.numberOfLines = 0
			label.textColor = color

		}
		static public func subtitle(_ label:UILabel, color:UIColor = #colorLiteral(red: 0.2349999994, green: 0.2349999994, blue: 0.2349999994, alpha: 1)) {
			label.font = Georgia.Font.bodyItalic
			label.numberOfLines = 0
			label.textColor = color
			
		}
		static public func largeTitle(_ label:UILabel, color:UIColor = #colorLiteral(red: 0.2349999994, green: 0.2349999994, blue: 0.2349999994, alpha: 1)) {
			label.font = Georgia.Font.largeTitle
			label.numberOfLines = 0
			label.textColor = color
			
		}
		static public func veryLargeTitle(_ label:UILabel, color:UIColor = .primaryInfo) {
			label.font = Georgia.Font.veryLargeTitle
			label.numberOfLines = 0
			label.textColor = color
			
		}
	}
}
