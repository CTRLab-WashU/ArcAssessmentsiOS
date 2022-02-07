//
//  EarningDetailGoalView.swift
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

import Foundation

import UIKit

public class EarningsDetailGoalView : UIView {
	weak var bodyLabel:ACLabel!
	weak var valueLabel:ACLabel!
	init() {
		super.init(frame: .zero)
		build()
	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		build()
	}
	func build() {
		backgroundColor = .clear
		isOpaque = false
		stack { [unowned self] in
			$0.attachTo(view: $0.superview, margins: UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24))
			$0.distribution = .fill
			self.bodyLabel = $0.acLabel {
				Roboto.Style.body($0, color:.white)
				$0.textAlignment = .left
			}
			self.valueLabel =  $0.acLabel {
				Roboto.Style.body($0, color:.white)
				$0.textAlignment = .right
			}
		}
	}
	public func set(body:String) {
		bodyLabel.text = body
	}
	public func set(value:String) {
		valueLabel.text = value
	}
}

extension UIView {
	@discardableResult
	public func earningsDetailGoalView(apply closure: (EarningsDetailGoalView) -> Void) -> EarningsDetailGoalView {
		return custom(EarningsDetailGoalView(), apply: closure)
	}
}


