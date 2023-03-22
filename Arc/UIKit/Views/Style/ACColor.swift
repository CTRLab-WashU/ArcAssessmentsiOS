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
    
    static let pricesTestBackground:UIColor = UIColor(named:"PriceTestBackground", in: ACColor.colorsModule, compatibleWith: nil)!
    
	//Goals
	static let goalHeader:UIColor = UIColor(named:"Goal Header", in: ACColor.colorsModule, compatibleWith: nil)!
	static let calendarItemBackground:UIColor = UIColor(named: "Calendar Item Background", in: ACColor.colorsModule, compatibleWith: nil)!
	//Badge
	static let badgeText:UIColor = UIColor(named:"Badge Text", in: ACColor.colorsModule, compatibleWith: nil)!
	static let badgeBackground:UIColor = UIColor(named:"Badge Background", in: ACColor.colorsModule, compatibleWith: nil)!
	static let badgeGradientStart:UIColor =  UIColor(named:"Badge Gradient Start", in: ACColor.colorsModule, compatibleWith: nil)!
	static let badgeGradientEnd:UIColor = UIColor(named:"Badge Gradient End", in: ACColor.colorsModule, compatibleWith: nil)!
	static let badgeGray:UIColor = UIColor(named:"Badge Gray", in: ACColor.colorsModule, compatibleWith: nil)!

	
	
	//Primary colors
	static let primary:UIColor = UIColor(named:"Primary", in: ACColor.colorsModule, compatibleWith: nil)!
    static let primaryDate:UIColor = UIColor(named:"Primary Date", in: ACColor.colorsModule, compatibleWith: nil)!
	static let primaryGradient:UIColor = UIColor(named:"Primary Gradient", in: ACColor.colorsModule, compatibleWith: nil)!
	static let primaryInfo:UIColor = UIColor(named:"Primary Info", in: ACColor.colorsModule, compatibleWith: nil)!
	static let primaryLinebreak:UIColor = UIColor(named:"Primary Linebreak", in: ACColor.colorsModule, compatibleWith: nil)!
	static let primarySectionBackground:UIColor = UIColor(named:"Primary Section Background", in: ACColor.colorsModule, compatibleWith: nil)!
	static let primarySelected:UIColor = UIColor(named:"Primary Selected", in: ACColor.colorsModule, compatibleWith: nil)!
	static let primaryText:UIColor = UIColor(named:"Primary Text", in: ACColor.colorsModule, compatibleWith: nil)!
	
	static let secondary:UIColor = UIColor(named:"Secondary", in: ACColor.colorsModule, compatibleWith: nil)!
	static let secondaryBackButtonBackground:UIColor = UIColor(named:"Secondary Back Button Background", in: ACColor.colorsModule, compatibleWith: nil)!
	static let secondaryBackground:UIColor = UIColor(named:"Secondary Background", in: ACColor.colorsModule, compatibleWith: nil)!
    static let secondaryDate:UIColor = UIColor(named:"Secondary Date", in: ACColor.colorsModule, compatibleWith: nil)!
	static let secondaryGradient:UIColor = UIColor(named:"Secondary Gradient", in: ACColor.colorsModule, compatibleWith: nil)!
	static let secondaryText:UIColor = UIColor(named:"Secondary Text", in: ACColor.colorsModule, compatibleWith: nil)!
	
	static let error:UIColor = UIColor(named:"Error", in: ACColor.colorsModule, compatibleWith: nil)!
	static let highlight:UIColor = UIColor(named:"Highlight", in: ACColor.colorsModule, compatibleWith: nil)!
	static let hintFill:UIColor = UIColor(named:"HintFill", in: ACColor.colorsModule, compatibleWith: nil)!
	static let horizontalSeparator:UIColor = UIColor(named:"HorizontalSeparator", in: ACColor.colorsModule, compatibleWith: nil)!
	static let modalFade:UIColor = UIColor(named:"Modal Fade", in: ACColor.colorsModule, compatibleWith: nil)!
	static let primaryBackground:UIColor = UIColor(named:"Primary Background", in: ACColor.colorsModule, compatibleWith: nil)!
	
	static let progressWeek:UIColor = UIColor(named:"ProgressWeek", in: ACColor.colorsModule, compatibleWith: nil)!
	static let resourcesSeparator:UIColor = UIColor(named:"Resources Separator", in: ACColor.colorsModule, compatibleWith: nil)!
	
	static let tutorialHighLight:UIColor = UIColor(named:"TutorialHighlight", in: ACColor.colorsModule, compatibleWith: nil)!
	static let primaryInnerTop:UIColor = UIColor(named:"PrimaryInnerTop", in: ACColor.colorsModule, compatibleWith: nil)!
	static let primaryInnerBottom:UIColor = UIColor(named:"PrimaryInnerBottom", in: ACColor.colorsModule, compatibleWith: nil)!
	static let secondaryInnerTop:UIColor = UIColor(named:"SecondaryInnerTop", in: ACColor.colorsModule, compatibleWith: nil)!
	static let secondaryInnerBottom:UIColor = UIColor(named:"SecondaryInnerBottom", in: ACColor.colorsModule, compatibleWith: nil)!
	
}

public struct ACColor {
    
    public static var colorsModule = Bundle.module
	
	//Goals
    static public let goalHeader:UIColor = UIColor(named:"Goal Header", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let calendarItemBackground:UIColor = UIColor(named: "Calendar Item Background", in: ACColor.colorsModule, compatibleWith: nil)!
	//Badges
	static public let badgeText:UIColor = UIColor(named:"Badge Text", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let badgeBackground:UIColor = UIColor(named:"Badge Background", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let badgeGradientStart:UIColor =  UIColor(named:"Badge Gradient Start", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let badgeGradientEnd:UIColor = UIColor(named:"Badge Gradient End", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let badgeGray:UIColor = UIColor(named:"Badge Gray", in: ACColor.colorsModule, compatibleWith: nil)!

	
	
	//Primary App colors
	static public let primary:UIColor = UIColor(named:"Primary", in: ACColor.colorsModule, compatibleWith: nil)!
    static public let primaryDate:UIColor = UIColor(named:"Primary Date", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let primaryGradient:UIColor = UIColor(named:"Primary Gradient", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let primaryInfo:UIColor = UIColor(named:"Primary Info", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let primaryLinebreak:UIColor = UIColor(named:"Primary Linebreak", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let primarySectionBackground:UIColor = UIColor(named:"Primary Section Background", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let primarySelected:UIColor = UIColor(named:"Primary Selected", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let primaryText:UIColor = UIColor(named:"Primary Text", in: ACColor.colorsModule, compatibleWith: nil)!
	
	static public let secondary:UIColor = UIColor(named:"Secondary", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let secondaryBackButtonBackground:UIColor = UIColor(named:"Secondary Back Button Background", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let secondaryBackground:UIColor = UIColor(named:"Secondary Background", in: ACColor.colorsModule, compatibleWith: nil)!
    static public let secondaryDate:UIColor = UIColor(named:"Secondary Date", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let secondaryGradient:UIColor = UIColor(named:"Secondary Gradient", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let secondaryText:UIColor = UIColor(named:"Secondary Text", in: ACColor.colorsModule, compatibleWith: nil)!
	
	static public let error:UIColor = UIColor(named:"Error", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let highlight:UIColor = UIColor(named:"Highlight", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let hintFill:UIColor = UIColor(named:"HintFill", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let horizontalSeparator:UIColor = UIColor(named:"HorizontalSeparator", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let modalFade:UIColor = UIColor(named:"Modal Fade", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let primaryBackground:UIColor = UIColor(named:"Primary Background", in: ACColor.colorsModule, compatibleWith: nil)!
	
	static public let progressWeek:UIColor = UIColor(named:"ProgressWeek", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let resourcesSeparator:UIColor = UIColor(named:"Resources Separator", in: ACColor.colorsModule, compatibleWith: nil)!
	
	static public let tutorialHighLight:UIColor = UIColor(named:"TutorialHighlight", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let primaryInnerTop:UIColor = UIColor(named:"PrimaryInnerTop", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let primaryInnerBottom:UIColor = UIColor(named:"PrimaryInnerBottom", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let secondaryInnerTop:UIColor = UIColor(named:"SecondaryInnerTop", in: ACColor.colorsModule, compatibleWith: nil)!
	static public let secondaryInnerBottom:UIColor = UIColor(named:"SecondaryInnerBottom", in: ACColor.colorsModule, compatibleWith: nil)!
	
}
