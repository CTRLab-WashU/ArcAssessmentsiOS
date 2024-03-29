//
//  TestProgressView.swift
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

public class TestProgressView:UIView {
	public weak var progressBar:CircularProgressView!
	public weak var divider:ACHorizontalBar!
	public weak var titleLabel:ACLabel!
	public weak var subtitleLabel:ACLabel!
	public weak var countLabel:ACLabel!
	public weak var maxLabel:ACLabel!
	
	public var defaultAnimation = Animate().duration(0.8).curve(.easeOut)
	public var title:String? {
		get {
			return titleLabel.text
		}
		set  {
			titleLabel.text = newValue
		}
	}
	public var subTitle:String? {
		get {
			return subtitleLabel.text
		}
		set {
			subtitleLabel.text = newValue
		}
	}
	public var dividerWidth:Double  = 1.0{
		didSet {
			divider.relativeWidth = CGFloat(min(dividerWidth, 1.0))
		}
	}
	public var count:Int = 0 {
		didSet {
			let old = Double(oldValue)/Double(maxCount)
			let new = Double(count)/Double(maxCount)
			
			defaultAnimation.stop()
			defaultAnimation = defaultAnimation.run {  [weak self] (t) -> Bool in
				self?.progressBar.progress = Math.lerp(a: old, b: new, t: t)
				
				return true
			}
			countLabel.text = "\(count)"

			
		}
	}
    public var maxCount:Int = 3 {
        didSet {
            self.maxLabel.text = "\(maxCount)"
        }
    }
	public init() {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = ACColor.primaryInfo
		progressBar = circularProgress { [unowned self] in
			$0.config.trackColor = ACColor.primary
			$0.config.barColor = ACColor.highlight
			$0.config.strokeWidth = 20
			$0.config.size = 216
			
			$0.ellipseConfig.color = ACColor.highlight
			$0.ellipseConfig.alpha = 0
			$0.ellipseConfig.size = 216
			$0.checkConfig.strokeColor = ACColor.primaryInfo
			$0.checkConfig.size = 100
			$0.layout {
				$0.centerX == self.centerXAnchor
				$0.centerY == self.centerYAnchor + 40
				$0.width == 216
				$0.height == 216
			}
			
			
			
			
			
		}
		let bar = progressBar!

		self.countLabel = acLabel {
			Georgia.Style.largeTitle($0, color: .white)
			$0.layer.zPosition = -1
			$0.text = "\(count)"
			$0.layout {
				$0.centerX == bar.centerXAnchor - 25
				$0.centerY == bar.centerYAnchor - 15
			}
		}
		
		
		
		self.maxLabel = acLabel {
			$0.layer.zPosition = -1
			
			Georgia.Style.largeTitle($0, color: .white)
			$0.text = "\(maxCount)"
			$0.layout {
				$0.centerX == bar.centerXAnchor + 20
				$0.centerY == bar.centerYAnchor + 10
			}
		}
		
		
		self.divider = acHorizontalBar {
			$0.color = ACColor.highlight
			$0.layer.zPosition = -1
			
			$0.transform = CGAffineTransform.identity.rotated(by: CGFloat(Math.toRadians(-60.0)))
			$0.relativeWidth = 1.0
			$0.layout {
				$0.centerX == bar.centerXAnchor
				$0.centerY == bar.centerYAnchor
				$0.width == 40
				$0.height == 2
				
			}
		}
		
		sendSubviewToBack(countLabel)
		sendSubviewToBack(maxLabel)
		sendSubviewToBack(divider)

		stack { [unowned self] in
			$0.axis = .vertical
			$0.alignment = .center
			$0.spacing = 8
			self.titleLabel = $0.acLabel {
				Roboto.Style.headingBold($0, color: .white)
                $0.numberOfLines = 0
                $0.textAlignment = .center
			}
			self.subtitleLabel = $0.acLabel {
				Georgia.Style.subtitle($0, color: .white)
			}
			$0.layout {
				$0.centerX == self.centerXAnchor ~ 1000
				$0.bottom == self.progressBar.topAnchor - 40
                $0.leading == self.layoutMarginsGuide.leadingAnchor + 16 ~ 999
                $0.trailing == self.layoutMarginsGuide.trailingAnchor + 16 ~ 999
			}
			
		}
		
		
		
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
