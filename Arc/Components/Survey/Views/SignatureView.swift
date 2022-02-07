//
//  SignatureView.swift
//  ARC
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

public enum SignatureViewContentState {
    case empty, dirty
}
public protocol SignatureViewDelegate : class {
    func signatureViewContentChanged(state:SignatureViewContentState)
    
}
open class SignatureView: BorderedUIView, SurveyInput {
	public var parentScrollView: UIScrollView? {
		didSet {
			parentScrollView?.delaysContentTouches = false
		}
	}
    
	
    public var isBottomAnchored: Bool = true
    
    public var orientation: UIStackView.Alignment = .bottom
  
    
	public weak var surveyInputDelegate: SurveyInputDelegate?

    public var path:UIBezierPath = UIBezierPath()
    public var state:SignatureViewContentState = .empty
    weak public var signatureDelegate:SignatureViewDelegate?
    
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        isExclusiveTouch = true
        surveyInputDelegate?.didFinishSetup()
//		didFinishSetup?()
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
        // Drawing code
        UIColor(named:"Primary")!.set()
        path.stroke()
    }

    public func getValue() -> QuestionResponse? {
        guard let data = save() else {
            return nil
        }
        return AnyResponse(type: .image, value: data)
    }
    
    public func setValue(_ value: QuestionResponse?) {
        
    }
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let location = touches.first?.location(in: self) else {
            return
        }
        parentScrollView?.isScrollEnabled = false
        path.move(to: location)
    }
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        parentScrollView?.isScrollEnabled = false

        path.addLine(to: location)
        self.setNeedsDisplay()
        
    }
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        parentScrollView?.isScrollEnabled = true
        state = .dirty
        signatureDelegate?.signatureViewContentChanged(state: .dirty)
		surveyInputDelegate?.didChangeValue()
        
//        didChangeValue?()
		
    }
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        parentScrollView?.isScrollEnabled = true

    }
    @IBAction func xPressed(sender:UIButton) {
        clear()
        
    }
    public func clear(){
        path = UIBezierPath()
        self.setNeedsDisplay()
        state = .empty
        signatureDelegate?.signatureViewContentChanged(state: .empty)
		surveyInputDelegate?.didChangeValue()
        
//        didChangeValue?()
    }
    public func save() -> UIImage?{
        
        guard state != .empty else {
            return nil
        }
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        
        return img
    }
	
	public func supplementaryViews(for view: UIView) {
		view.acButton {
			$0.primaryColor = .clear
			$0.secondaryColor = .clear
			$0.topColor = .clear
			$0.bottomColor = .clear
			$0.setTitleColor(UIColor(named:"Primary"), for: .normal)
            
			$0.setTitle("UNDO".localized(ACTranslationKey.idverify_undo), for: .normal)
			Roboto.Style.bodyBold($0.titleLabel!, color: UIColor(named:"Primary"))
			Roboto.PostProcess.link($0)
			$0.addAction {
				[weak self] in
				self?.clear()
			}
		}
	}
    
}


extension UIView {
	
	@discardableResult
	public func signatureInput(apply closure: (SignatureView) -> Void) -> SignatureView {
		return custom(SignatureView.get(), apply: closure)
	}
	
}
