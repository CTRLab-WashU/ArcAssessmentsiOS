//
//  TestCountDownView.swift
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

public class TestCountDownView: UIView {
	public weak var countLabel:ACLabel!
	public override init(frame: CGRect) {
		super.init(frame: .zero)
		build()
		
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		build()
	}
	
	public func build(){
		backgroundColor = .white
		stack { [weak self] in
			let stack = $0
			
			
			$0.layout {
				$0.centerX == self!.centerXAnchor
				$0.centerY == self!.centerYAnchor - 40
				
			}
			$0.axis = .vertical
			$0.alignment = .center
			$0.acLabel {
				stack.setCustomSpacing(32, after: $0)
				$0.text = "".localized(ACTranslationKey.testing_begin)
				Roboto.Style.subHeading($0, color: ACColor.badgeText)
			}

			self?.countLabel = $0.acLabel {
				
				stack.setCustomSpacing(12, after: $0)
				$0.text = " 3 "
				Georgia.Style.veryLargeTitle($0)
			}
			
			$0.acHorizontalBar {
				$0.layout {
					$0.width == 70
					$0.height == 2
				}
				$0.relativeWidth = 1.0
				
				
			}
		}
	}
}
