//
//  ACColor.swift
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
public extension UIColor {
    
    static let pricesTestBackground:UIColor = UIColor(named:"PriceTestBackground", in: Bundle.module, compatibleWith: nil)!
	//Goals
	static let goalHeader:UIColor = UIColor(named:"Goal Header", in: Bundle.module, compatibleWith: nil)!
	static let calendarItemBackground:UIColor = UIColor(named: "Calendar Item Background", in: Bundle.module, compatibleWith: nil)!
	//Badge
	static let badgeText:UIColor = UIColor(named:"Badge Text", in: Bundle.module, compatibleWith: nil)!
	static let badgeBackground:UIColor = UIColor(named:"Badge Background", in: Bundle.module, compatibleWith: nil)!
	static let badgeGradientStart:UIColor =  UIColor(named:"Badge Gradient Start", in: Bundle.module, compatibleWith: nil)!
	static let badgeGradientEnd:UIColor = UIColor(named:"Badge Gradient End", in: Bundle.module, compatibleWith: nil)!
	static let badgeGray:UIColor = UIColor(named:"Badge Gray", in: Bundle.module, compatibleWith: nil)!

	
	
	//Primary colors
	static let primary:UIColor = UIColor(named:"Primary", in: Bundle.module, compatibleWith: nil)!
    static let primaryDate:UIColor = UIColor(named:"Primary Date", in: Bundle.module, compatibleWith: nil)!
	static let primaryGradient:UIColor = UIColor(named:"Primary Gradient", in: Bundle.module, compatibleWith: nil)!
	static let primaryInfo:UIColor = UIColor(named:"Primary Info", in: Bundle.module, compatibleWith: nil)!
	static let primaryLinebreak:UIColor = UIColor(named:"Primary Linebreak", in: Bundle.module, compatibleWith: nil)!
	static let primarySectionBackground:UIColor = UIColor(named:"Primary Section Background", in: Bundle.module, compatibleWith: nil)!
	static let primarySelected:UIColor = UIColor(named:"Primary Selected", in: Bundle.module, compatibleWith: nil)!
	static let primaryText:UIColor = UIColor(named:"Primary Text", in: Bundle.module, compatibleWith: nil)!
	
	static let secondary:UIColor = UIColor(named:"Secondary", in: Bundle.module, compatibleWith: nil)!
	static let secondaryBackButtonBackground:UIColor = UIColor(named:"Secondary Back Button Background", in: Bundle.module, compatibleWith: nil)!
	static let secondaryBackground:UIColor = UIColor(named:"Secondary Background", in: Bundle.module, compatibleWith: nil)!
    static let secondaryDate:UIColor = UIColor(named:"Secondary Date", in: Bundle.module, compatibleWith: nil)!
	static let secondaryGradient:UIColor = UIColor(named:"Secondary Gradient", in: Bundle.module, compatibleWith: nil)!
	static let secondaryText:UIColor = UIColor(named:"Secondary Text", in: Bundle.module, compatibleWith: nil)!
	
	static let error:UIColor = UIColor(named:"Error", in: Bundle.module, compatibleWith: nil)!
	static let highlight:UIColor = UIColor(named:"Highlight", in: Bundle.module, compatibleWith: nil)!
	static let hintFill:UIColor = UIColor(named:"HintFill", in: Bundle.module, compatibleWith: nil)!
	static let horizontalSeparator:UIColor = UIColor(named:"HorizontalSeparator", in: Bundle.module, compatibleWith: nil)!
	static let modalFade:UIColor = UIColor(named:"Modal Fade", in: Bundle.module, compatibleWith: nil)!
	static let primaryBackground:UIColor = UIColor(named:"Primary Background", in: Bundle.module, compatibleWith: nil)!
	
	static let progressWeek:UIColor = UIColor(named:"ProgressWeek", in: Bundle.module, compatibleWith: nil)!
	static let resourcesSeparator:UIColor = UIColor(named:"Resources Separator", in: Bundle.module, compatibleWith: nil)!
	
	static let tutorialHighLight:UIColor = UIColor(named:"TutorialHighlight", in: Bundle.module, compatibleWith: nil)!
	static let primaryInnerTop:UIColor = UIColor(named:"PrimaryInnerTop", in: Bundle.module, compatibleWith: nil)!
	static let primaryInnerBottom:UIColor = UIColor(named:"PrimaryInnerBottom", in: Bundle.module, compatibleWith: nil)!
	static let secondaryInnerTop:UIColor = UIColor(named:"SecondaryInnerTop", in: Bundle.module, compatibleWith: nil)!
	static let secondaryInnerBottom:UIColor = UIColor(named:"SecondaryInnerBottom", in: Bundle.module, compatibleWith: nil)!
	
}

public struct ACColor {
	
	//Goals
	static public var goalHeader:UIColor = UIColor(named:"Goal Header", in: Bundle.module, compatibleWith: nil)!
	static public var calendarItemBackground:UIColor = UIColor(named: "Calendar Item Background", in: Bundle.module, compatibleWith: nil)!
	//Badges
	static public var badgeText:UIColor = UIColor(named:"Badge Text", in: Bundle.module, compatibleWith: nil)!
	static public var badgeBackground:UIColor = UIColor(named:"Badge Background", in: Bundle.module, compatibleWith: nil)!
	static public var badgeGradientStart:UIColor =  UIColor(named:"Badge Gradient Start", in: Bundle.module, compatibleWith: nil)!
	static public var badgeGradientEnd:UIColor = UIColor(named:"Badge Gradient End", in: Bundle.module, compatibleWith: nil)!
	static public var badgeGray:UIColor = UIColor(named:"Badge Gray", in: Bundle.module, compatibleWith: nil)!

	
	
	//Primary App colors
	static public var primary:UIColor = UIColor(named:"Primary", in: Bundle.module, compatibleWith: nil)!
    static public var primaryDate:UIColor = UIColor(named:"Primary Date", in: Bundle.module, compatibleWith: nil)!
	static public var primaryGradient:UIColor = UIColor(named:"Primary Gradient", in: Bundle.module, compatibleWith: nil)!
	static public var primaryInfo:UIColor = UIColor(named:"Primary Info", in: Bundle.module, compatibleWith: nil)!
	static public var primaryLinebreak:UIColor = UIColor(named:"Primary Linebreak", in: Bundle.module, compatibleWith: nil)!
	static public var primarySectionBackground:UIColor = UIColor(named:"Primary Section Background", in: Bundle.module, compatibleWith: nil)!
	static public var primarySelected:UIColor = UIColor(named:"Primary Selected", in: Bundle.module, compatibleWith: nil)!
	static public var primaryText:UIColor = UIColor(named:"Primary Text", in: Bundle.module, compatibleWith: nil)!
	
	static public var secondary:UIColor = UIColor(named:"Secondary", in: Bundle.module, compatibleWith: nil)!
	static public var secondaryBackButtonBackground:UIColor = UIColor(named:"Secondary Back Button Background", in: Bundle.module, compatibleWith: nil)!
	static public var secondaryBackground:UIColor = UIColor(named:"Secondary Background", in: Bundle.module, compatibleWith: nil)!
    static public var secondaryDate:UIColor = UIColor(named:"Secondary Date", in: Bundle.module, compatibleWith: nil)!
	static public var secondaryGradient:UIColor = UIColor(named:"Secondary Gradient", in: Bundle.module, compatibleWith: nil)!
	static public var secondaryText:UIColor = UIColor(named:"Secondary Text", in: Bundle.module, compatibleWith: nil)!
	
	static public var error:UIColor = UIColor(named:"Error", in: Bundle.module, compatibleWith: nil)!
	static public var highlight:UIColor = UIColor(named:"Highlight", in: Bundle.module, compatibleWith: nil)!
	static public var hintFill:UIColor = UIColor(named:"HintFill", in: Bundle.module, compatibleWith: nil)!
	static public var horizontalSeparator:UIColor = UIColor(named:"HorizontalSeparator", in: Bundle.module, compatibleWith: nil)!
	static public var modalFade:UIColor = UIColor(named:"Modal Fade", in: Bundle.module, compatibleWith: nil)!
	static public var primaryBackground:UIColor = UIColor(named:"Primary Background", in: Bundle.module, compatibleWith: nil)!
	
	static public var progressWeek:UIColor = UIColor(named:"ProgressWeek", in: Bundle.module, compatibleWith: nil)!
	static public var resourcesSeparator:UIColor = UIColor(named:"Resources Separator", in: Bundle.module, compatibleWith: nil)!
	
	static public var tutorialHighLight:UIColor = UIColor(named:"TutorialHighlight", in: Bundle.module, compatibleWith: nil)!
	static public var primaryInnerTop:UIColor = UIColor(named:"PrimaryInnerTop", in: Bundle.module, compatibleWith: nil)!
	static public var primaryInnerBottom:UIColor = UIColor(named:"PrimaryInnerBottom", in: Bundle.module, compatibleWith: nil)!
	static public var secondaryInnerTop:UIColor = UIColor(named:"SecondaryInnerTop", in: Bundle.module, compatibleWith: nil)!
	static public var secondaryInnerBottom:UIColor = UIColor(named:"SecondaryInnerBottom", in: Bundle.module, compatibleWith: nil)!
	
}
