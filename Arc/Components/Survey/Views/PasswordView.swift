//
//  PasswordView.swift
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
open class PasswordView : UIView, SurveyInput, UITextFieldDelegate {
    public var orientation: UIStackView.Alignment = .top
    

	@IBOutlet weak var textField:UITextField!
	@IBOutlet weak var secureButton:UIButton!
	@IBOutlet weak var borderView:BorderedUIView!
	public weak var surveyInputDelegate: SurveyInputDelegate?
	override open func awakeFromNib() {
		super.awakeFromNib()
        set(secure: false)
		textField.inputAccessoryView = getInputAccessoryView(selector: #selector(PasswordView.doneButtonAction))
		surveyInputDelegate?.didFinishSetup()
	}
	
	@IBAction func toggleSecure(_ sender: Any) {
		set(secure: !textField.isSecureTextEntry)
	}
    
    func openKeyboard() {
        textField.becomeFirstResponder()
    }
    
	func set(secure: Bool) {
		textField.isSecureTextEntry = secure
		secureButton.isSelected = !secure
	}
	public func getValue() -> QuestionResponse? {
		return AnyResponse(type: .password, value: textField.text)
	}
	public func setValue(_ value: QuestionResponse?) {
		textField.text = String(describing: value?.value as? String ?? "")
	}
	@objc func doneButtonAction() {
        surveyInputDelegate?.tryNextPressed()
		textField.resignFirstResponder()
	}
	public func setError(message: String?) {
		if message != nil {
            borderView.borderColor = ACColor.error
			borderView.layoutSubviews()
		} else {
			borderView.borderColor = ACColor.primary
            borderView.layoutSubviews()
		}
	}
	
	
}
