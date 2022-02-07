//
//  CircularProgressGroupStackView.swift
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

public class ACCircularProgressGroupStackView : UIStackView {
	private var progressViews:[CircularProgressView] = []
	public var config = Drawing.CircularBar()
	public var checkConfig = Drawing.CheckMark()
	public var ellipseConfig = Drawing.Ellipse()
	private var contentStack:UIStackView!

	public init() {
		super.init(frame: .zero)
		
		config.strokeWidth =  6
		config.trackColor = ACColor.highlight
		config.barColor = ACColor.primaryInfo
		config.size = 64
		checkConfig.strokeColor = ACColor.highlight
		checkConfig.size = 34
		ellipseConfig.size = 64
		ellipseConfig.color = ACColor.primaryInfo
		
		translatesAutoresizingMaskIntoConstraints = false
		axis = .vertical
		alignment = .leading
		contentStack = stack {
			$0.distribution = .fillEqually
			$0.spacing = 8
			
		}
		

	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func addProgressViews(count:Int) {
		
		
		
		
		for _ in 0 ..< count {
			progressViews.append (contentStack.circularProgress {
				//Make sure to pass in updated configurations

				$0.config = config
				$0.checkConfig = checkConfig
				$0.ellipseConfig = ellipseConfig
				$0.progress = 0
			})
		}
	}
	
	public func addProgressView(progress:Double) {
		
		
		
		progressViews.append (contentStack.circularProgress {
			
			//Make sure to pass in updated configurations
			$0.config = config
			$0.checkConfig = checkConfig
			$0.ellipseConfig = ellipseConfig
			$0.progress = progress
		})
	}
	public func set(progress:Double, for index:Int) {
		progressViews[index].progress = progress
	}
	public func clearProgressViews() {
		removeSubviews()
		progressViews = []
	}
}
extension UIView {
	
	@discardableResult
	public func circularProgressGroup(apply closure: (ACCircularProgressGroupStackView) -> Void) -> ACCircularProgressGroupStackView {
		return custom(ACCircularProgressGroupStackView(), apply: closure)
	}
	
}
