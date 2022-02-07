// CircularProgressView.swift
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

import UIKit

public class CircularProgressView : UIView {
	
	public struct Config {
		var strokeWidth:CGFloat = 10
		var trackColor:UIColor = ACColor.highlight
		var barColor:UIColor = ACColor.primaryInfo
		
	}
	private var completeAnimation = Animate().duration(0.5).curve(.easeOut)
	let trackPath = UIBezierPath()
	let barPath = UIBezierPath()
	let barEdgePath = UIBezierPath()
	
	var startAngle = (3.0 * CGFloat.pi)/2.0
	var endAngle = 2.0 * CGFloat.pi
	var config:Drawing.CircularBar = Drawing.CircularBar()
	var checkConfig:Drawing.CheckMark = Drawing.CheckMark()
	var ellipseConfig:Drawing.Ellipse = Drawing.Ellipse()
	
	var progress:Double = 0.1 {
		didSet {
			setNeedsDisplay()
			let curCompleteProgress = completeProgress
			var newCompleteProgress:Double = 0
			if progress >= 1.0 {
				newCompleteProgress = 1
			}
			
			completeAnimation.stop()
			
			completeAnimation.run { [weak self] (t) -> Bool in
				self?.completeProgress = Math.lerp(a: curCompleteProgress, b: newCompleteProgress, t: t)
				return true
			}
			
		}
	}
	
	private var completeProgress:Double = 0 {
		didSet {
			setNeedsDisplay()
			
		}
	}
	init() {
		super.init(frame: .zero)
		backgroundColor = .clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	public func configure(_ config:Drawing.CircularBar) {
		self.config = config
	}
	public func configure(_ config:Drawing.Ellipse) {
		self.ellipseConfig = config
	}
	public func configure(_ config:Drawing.CheckMark) {
		self.checkConfig = config

	}
	
	func runCompleteAnimation() {
		
		
	}
	public override var intrinsicContentSize: CGSize {
			return  CGSize(width:config.size, height:config.size)
	}
		
	override public func draw(_ rect: CGRect) {
		super.draw(rect)
		//Draw the radial circle using its own progress
		config.progress = progress
		config.draw(rect)
		
//		if(completeProgress > 0) {
			//Draw the check and cirlce using an internal progress managed by the view
			ellipseConfig.alpha = CGFloat(completeProgress)
			ellipseConfig.radius = Math.lerp(a: rect.width/4, b: rect.width/2 - config.strokeWidth, t: CGFloat(completeProgress))
			ellipseConfig.draw(rect)

			checkConfig.progress = completeProgress
			checkConfig.draw(rect)
//		}
		
		
		
	}
}


extension UIView {
	
	@discardableResult
	public func circularProgress(apply closure: (CircularProgressView) -> Void) -> CircularProgressView {
		return custom(CircularProgressView(), apply: closure)
	}
	
}
