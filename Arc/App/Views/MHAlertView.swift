//
//  MHAlertView.swift
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

open class MHAlertView: UIView {
	public enum ButtonType {
		case `default`(String, ()->())
		
		case cancel(String, ()->())
		
		//Wait the specified amount of time
		case wait(waitTime:TimeInterval, (MHAlertView)->())
		
		//Delay input for a specified amount of time
		case delayed(name:String, delayTime:TimeInterval, (MHAlertView)->())
	}
	var buttons:[ButtonType]?
	
	@IBOutlet weak var stack:UIStackView!
	@IBOutlet weak var messageLabel:UILabel!
	private var waitTimers:[Timer] = []
	private var delayTimer:Timer?
	private var buttonMap: [UIView:ButtonType] = [:]
    
    private var markupRenderer:HMMarkupRenderer
   
    public required init?(coder aDecoder: NSCoder) {
        //The message label will not exist at this point use a default first
        markupRenderer = HMMarkupRenderer(baseFont: .systemFont(ofSize: 14))
        super.init(coder: aDecoder)

    }
	override open func awakeFromNib() {
		super.awakeFromNib()
        markupRenderer = HMMarkupRenderer(baseFont: messageLabel.font)

	}
	public func set(message:String) {
		messageLabel.attributedText = markupRenderer.render(text: message)

        messageLabel.font = UIFont(name: "Roboto", size: 17)
	}
	public func set(message:String?, buttons:[ButtonType]) {
		//Clear timers in case of rapid reuse
		
		waitTimers.forEach {$0.invalidate()}
		waitTimers = []
		delayTimer?.invalidate()
		delayTimer = nil
		
		
		messageLabel.attributedText = markupRenderer.render(text: message ?? "")
		messageLabel.font = UIFont(name: "Roboto", size: 17)
        self.buttons = buttons
		buttonMap = [:]
		stack.removeSubviews()
		for button in buttons {
			if let b = get(buttonForType: button) {
				buttonMap[b] = button
				stack.addArrangedSubview(b)
			}
		}
		if delayTimer != nil && delayTimer!.isValid {
			self.set(enabled:false)
		}

		
		
	}
	private func get(buttonForType buttonType:ButtonType) -> UIView? {
		switch buttonType {
		case let .`default`(title, _):
			let button:PrimaryButton = .get()
			button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
			button.setTitle(title, for: .normal)
			return button
		case let .cancel(title, _):
			let button:CancelButton = .get()
			button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
			button.setTitle(title, for: .normal)
			return button
		
		//We won't return a button here because there is no button to show.
		case let .wait(waitTime, callBack):
			waitTimers.append( Timer.scheduledTimer(withTimeInterval: waitTime, repeats: false) { (timer) in
				callBack(self)
				
			})
			return nil
		
		//Here we return a button but also disable its use for a period of time
		case let .delayed(title, delayTime, _):
			waitTimers.forEach { $0.fireDate += delayTime }
			
			//Create a button
			let button:PrimaryButton = .get()
			button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
			button.setTitle(title, for: .normal)
			button.isEnabled = false
			
			
			delayTimer = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: false, block: { (timer) in
				self.set(enabled:true)
				
			})
			
			return button

		
		}
		
	}
	public func set(enabled: Bool) {
		//If we set a delay timer
		for view in stack.arrangedSubviews {
			if let button = view as? UIButton {
				button.isEnabled = enabled
			}
		}
	
	}
	@objc func buttonTapped(_ sender:UIButton) {
		if let buttonType = buttonMap[sender] {
		
			switch buttonType {
			case let .`default`(_, callBack):
				callBack()
			case let .cancel(_, callBack):
				callBack()
			case let .delayed(_, _, callBack):
				callBack(self)
				
			default:
				break
			}
			self.remove()
		}
	}
	
	open func remove() {
		if delayTimer?.isValid ?? false {
			delayTimer?.invalidate()
		}
		
		waitTimers.forEach {
			if $0.isValid {
				$0.invalidate()
			}
		}
		
		UIView.animate(withDuration: 0.15, delay: 0.1, options: .curveEaseOut, animations: {
			self.alpha = 0
		}) { [weak self] (_)  in
			self?.removeFromSuperview()

		}
	}
}
