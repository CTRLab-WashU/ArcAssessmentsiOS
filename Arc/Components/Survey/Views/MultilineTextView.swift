//
//  MultilineTextView.swift
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
open class MultilineTextView : UIView, SurveyInput, UITextViewDelegate {
	public weak var surveyInputDelegate: SurveyInputDelegate?

    public var orientation: UIStackView.Alignment = .top
    

    @IBOutlet public weak var textView: UITextView!
	public var maxCharacters:Int?
	public var minCharacters:Int?
	public var keyboardType:UIKeyboardType = .default {
		didSet {
			textView.keyboardType = keyboardType
		}
	}
    override open func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.layer.borderColor = UIColor(named: "Primary")!.cgColor
        textView.layer.borderWidth = 2.0
        textView.layer.cornerRadius = 8.0
		textView.inputAccessoryView = getInputAccessoryView(selector: #selector(endEditing(_:)))
        textView.becomeFirstResponder()
		surveyInputDelegate?.didFinishSetup()
    }
    
    override open var canBecomeFirstResponder: Bool {
        return true
    }
    
    public func getValue() -> QuestionResponse? {
		guard textView.text.count >= minCharacters ?? 1 else {
			return nil
		}
		if let max = maxCharacters {
			guard textView.text.count <= max else {
				return nil
			}
		}
        return AnyResponse(type: .multilineText,
						   value: textView.text)
    }
	public func setValue(_ value: QuestionResponse?) {
		textView.text = String(describing:  value?.value as? String ?? "")
		if let max = maxCharacters {
			textView.text = String(textView.text.prefix(max))
		}
    }
	
	
	public func setError(message: String?) {
		if message != nil {
			textView.layer.borderColor = UIColor(named: "Error")!.cgColor

		} else {
			textView.layer.borderColor = UIColor(named: "Primary")!.cgColor

		}
	}
	
	func getError() -> String? {
		return ""
	}
	public func textViewDidChange(_ textView: UITextView) {
		if let max = maxCharacters {
			textView.text = String(textView.text.prefix(max))
		}
		surveyInputDelegate?.didChangeValue()
	}
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // If the return key is "done" and not "return", dismiss keyboard
        if textView.returnKeyType == .done && text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
