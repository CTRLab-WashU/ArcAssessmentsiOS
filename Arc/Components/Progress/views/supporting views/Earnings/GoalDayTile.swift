//
//  GoalDayTile.swift
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

public class GoalDayTile: UIView {
	public weak var progressView:CircularProgressView!
	weak var titleLabel:ACLabel!
	override init(frame: CGRect) {
		super.init(frame: .zero)
		build()
	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		build()
	}
	
	func build() {
		translatesAutoresizingMaskIntoConstraints = false
		stack {[unowned self] in 
			$0.axis = .vertical
			$0.spacing = 8
			$0.alignment = .center
			$0.attachTo(view: $0.superview, margins: UIEdgeInsets(top: 12, left: 0, bottom: 4, right: 0))
			self.progressView = $0.circularProgress {
				$0.layout {
					$0.width == 24 ~ 999
					$0.height == 24 ~ 999

				}
				$0.config.strokeWidth = 2
				$0.config.size = 24
				$0.ellipseConfig.size = 13
				$0.checkConfig.size = 13
				$0.config.trackColor = ACColor.highlight
				$0.config.barColor = ACColor.primary
			}
			self.titleLabel = $0.acLabel {
				Roboto.Style.body($0, color: ACColor.badgeText)
			}
		}
	}
	public func set(title:String) {
		titleLabel.text = title
	}
	
	public func set(progress:Double) {
		progressView.progress = progress
	}
}
extension UIView {
	@discardableResult
	public func goalDayTile(apply closure: (GoalDayTile) -> Void) -> GoalDayTile {
		return custom(GoalDayTile(), apply: closure)
	}
}

