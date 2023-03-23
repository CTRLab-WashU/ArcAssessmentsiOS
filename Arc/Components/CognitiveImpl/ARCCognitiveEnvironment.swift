//
//  SampleAppEnvironment.swift
//  SampleApp
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

// This class can be used to customize the Arc library
open class ARCCognitiveEnvironment : ArcEnvironment {
    
    public var appNavigation: AppNavigationController = ARCCognitiveNavigationController()
    
    public init() {
        
    }
    
    open var shouldChooseLocale: Bool {
        false
    }
    
    open var shouldDisplayDateReminderNotifications: Bool {
        return true
    }
    
    open var hidesChangeAvailabilityDuringTest: Bool {
        return true
    }
    
    public func configure() {
        //Use this to set class variables or perform setup before the app runs
        SliderView.hideSelection = true
    }
    
    open var priceTestType:PriceTestType {
        return .normal
    }
    
    open var gridTestType:GridTestType {
        //return .normal
        return .extended
    }
}
