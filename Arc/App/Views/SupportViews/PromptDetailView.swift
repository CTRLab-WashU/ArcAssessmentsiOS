//
//  PromptDetailView.swift
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


public class PromptDetailView: UIStackView {
	
	public var separatorWidth:CGFloat {
		get {
			return separator.relativeWidth
		}
		set {
			separator.relativeWidth = newValue
		}
	}
	public var detail:String? {
		get {
			return detailsLabel.text
		}
		set {
			detailsLabel.text = newValue
		}
	}
	weak var separator:ACHorizontalBar!
	weak var promptLabel:UILabel!
	weak var detailsLabel:UILabel!
	
	var renderer:HMMarkupRenderer?
	public init() {

		super.init(frame: .zero)
		axis = .vertical
		alignment = .fill
		spacing = 10
		promptLabel = acLabel {
			$0.text = ""
			Roboto.Style.heading($0)
			$0.textColor = .primaryText
			
		}
		separator = acHorizontalBar {
			$0.relativeWidth = 0.15
			$0.color = ACColor.horizontalSeparator
			$0.layout {
				$0.height == 2 ~ 999
				
			}
		}
		detailsLabel = acLabel {
			
			Roboto.Style.body($0)
			$0.text = ""
			$0.textColor = .primaryText

			
		}
		
	}
	public func setPrompt(_ text:String?, template:[String:String] = [:]) {
		renderer = HMMarkupRenderer(baseFont: promptLabel.font)

		let markedUpString = renderer?.render(text: text ?? "", template:template)
		promptLabel.attributedText = markedUpString
		
	}
	public func setDetail(_ text:String?) {
		detailsLabel.text = text
	}
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
extension UIView {
	
	@discardableResult
	public func promptDetail(apply closure: (PromptDetailView) -> Void) -> PromptDetailView {
		return custom(PromptDetailView(), apply: closure)
	}
	
}

