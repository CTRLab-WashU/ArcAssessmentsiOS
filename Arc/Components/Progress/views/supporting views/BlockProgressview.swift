//
//  BlockProgressview.swift
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

public class BlockProgressview: UIStackView {

	var maxBlockCount:Int = 12
	var currentBlock:Int = 0
	var color:UIColor = #colorLiteral(red: 0.400000006, green: 0.7799999714, blue: 0.7799999714, alpha: 1)
	
	init() {
		super.init(frame: .zero)
		spacing = 4
		axis = .horizontal
		alignment = .center
		distribution = .fillEqually
	}
	public func set(count:Int, progress:Int, current:Int?) {
		removeSubviews()
		
		for i in 0 ..< count {
			view {
				$0.layer.cornerRadius = 2
				
				if i <= progress {
					$0.backgroundColor = color
					//If we set current make that block larger than the rest
					if i == current {
						$0.backgroundColor = color
						$0.layout {
							$0.height == 42
						}
					//Otherwise just fill it in
					} else {
						$0.layout {
							$0.height == 32
						}
					}
					//If progress hasn't reached this far hollow it out. 
				} else {
					$0.backgroundColor = .clear
					$0.layer.borderColor = color.cgColor
					$0.layer.borderWidth = 1
					$0.layout {
						$0.height == 32
					}
					
				}
			}
			
			
		}
	}
	required init(coder: NSCoder) {
		super.init(coder: coder)
	}
	
}
extension UIView {
	
	@discardableResult
	public func blockProgress(apply closure: (BlockProgressview) -> Void) -> BlockProgressview {
		return custom(BlockProgressview(), apply: closure)
	}
	
}
