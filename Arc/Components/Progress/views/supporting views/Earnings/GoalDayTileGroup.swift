//
//  GoalDayTileGroup.swift
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

public class GoalDayTileGroup: UIStackView {
	
	weak var contents:UIStackView!
	override init(frame: CGRect) {
		super.init(frame: .zero)
		build()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)
		build()
	}
	
	
	func build() {
		distribution = .fillEqually
		
	}
	public func add(tile name:String, progress:Double) {
		goalDayTile {
			
			$0.progressView.progress = progress
			$0.titleLabel.text = "*\(name)*"
            $0.progressView.checkConfig.strokeColor = ACColor.highlight
            $0.progressView.ellipseConfig.color = ACColor.primaryInfo
			if arrangedSubviews.count % 2 == 1 {
				$0.backgroundColor = ACColor.calendarItemBackground
			} else {
				$0.backgroundColor = .white
			}
		}
	}
	
	public func clear() {
		removeSubviews()
	}
	public func set(progress:Double, forIndex index:Int) {
		guard arrangedSubviews.count > 0 else {
			return
		}
		if let tile = arrangedSubviews[index] as? GoalDayTile {
			tile.set(progress: progress)
		}
	}
}
extension UIView {
	@discardableResult
	public func goalDayTileGroup(apply closure: (GoalDayTileGroup) -> Void) -> GoalDayTileGroup {
		return custom(GoalDayTileGroup(), apply: closure)
	}

}
