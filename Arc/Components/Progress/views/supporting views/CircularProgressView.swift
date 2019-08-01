import UIKit
import ArcUIKit
public class CircularProgressView : UIView {
	
	public struct Config {
		var strokeWidth:CGFloat = 10
		var trackColor:UIColor = .black
		var barColor:UIColor = .blue
		
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
