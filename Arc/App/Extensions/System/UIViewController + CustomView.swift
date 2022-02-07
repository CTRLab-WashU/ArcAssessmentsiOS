//
//  UIViewController + CustomView.swift
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

import Foundation
import UIKit

/// The HasCustomView protocol defines a customView property for UIViewControllers to be used in exchange of the regular view property.
/// In order for this to work, you have to provide a custom view to your UIViewController at the loadView() method.
public protocol HasCustomView {
	associatedtype CustomView: UIView
}

public extension HasCustomView where Self: UIViewController {
	/// The UIViewController's custom view.
	var customView: CustomView {
		guard let customView = view as? CustomView else {
			fatalError("Expected view to be of type \(CustomView.self) but got \(type(of: view)) instead")
		}
		return customView
	}
}
open class CustomViewController<CustomView: UIView>: ArcViewController {
	public var customView: CustomView {
		return view as! CustomView //Will never fail as we're overriding 'view'
	}
	
	override open func loadView() {
		view = CustomView()
	}
	
}
