//
//  Common.swift
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

import Foundation
import UIKit


@objc public enum ACTextStyle : Int{
    /*
     0 - "Roboto-Regular"
     1 - "Roboto-Black"
     2 - "Roboto-Light"
     3 - "Roboto-LightItalic"
     4 - "Roboto-Thin"
     5 - "Roboto-MediumItalic"
     6 - "Roboto-Medium"
     7 - "Roboto-Bold"
     8 - "Roboto-BlackItalic"
     9 - "Roboto-Italic"
     */
    static public let roboto = UIFont.fontNames(forFamilyName: "Roboto")
    
    /*
     0 "Georgia-BoldItalic"
     1 "Georgia-Italic"
     2 "Georgia"
     3 "Georgia-Bold"
     */
    static public let georgia = UIFont.fontNames(forFamilyName: "Georgia")

    case none, body, heading, title, introHeading, selectedBody
    
    var size:CGFloat {
        switch self {
        case .body, .selectedBody:
            return 18.0
        case .heading:
            return 26.0
        case .title:
            return 26.0
        case .introHeading:
            return 22.5
        
        default:
            return 18.0
        }
    }
    var font:UIFont? {
        var f:UIFont?
        switch self {
        
        case .body:
            f = UIFont(name: ACTextStyle.roboto[0], size: self.size)
   
        case .heading:
            f = UIFont(name: ACTextStyle.roboto[0], size: self.size)
       
        case .title:
            f = UIFont(name: ACTextStyle.roboto[7], size: self.size)
            
        case .introHeading:
            f = UIFont(name: ACTextStyle.georgia[1], size: self.size)
            
        case .selectedBody:
            f = UIFont(name: ACTextStyle.roboto[1], size: self.size)
        
        default:
            break
        }
        
        return f
    }
    
}

public enum PhoneClass {
    case iphoneSE, iphone678, iphone678Plus, iphoneX, iphoneXR, iphoneMax
    
    public static func getClass() -> PhoneClass {
        let width:CGFloat = UIScreen.main.bounds.width
        let height:CGFloat = UIScreen.main.bounds.height
        switch (width, height) {
        case (320, 568):
            return .iphoneSE
        case (375, 667):
            return .iphone678
        case (414, 736):
            return .iphone678Plus
        case (375, 812):
            return .iphoneX
        case (414, 896):
            return .iphoneXR
        case (414, 896):
            return .iphoneMax
        default:
            return .iphone678   //should never get here, but this seems like the safest size class to fall back on
        }
    }
}
