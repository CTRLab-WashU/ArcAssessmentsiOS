//
//  segmentedTextView.swift
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

public class SegmentedTextView : UIView, SurveyInput, UIKeyInput {
	
	public weak var surveyInputDelegate: SurveyInputDelegate?

    public var orientation: UIStackView.Alignment = .top
	public var problemsButton:UIButton?
	public var hideHelpButton:Bool = false
	@IBOutlet public weak var inputStack: UIStackView!
	public var shouldTryNext = true
	private var _value:[String] = [] {
		didSet {
			updateValue(newValue: self._value)
		}
	}
	
	
	//MARK: Text Input: Either override or assign default values to get
	//desired behavior
	
    public var autocapitalizationType: UITextAutocapitalizationType = .none
    public var autocorrectionType: UITextAutocorrectionType = .no
    @available(iOS 5.0, *)
    public var spellCheckingType: UITextSpellCheckingType = .no
    @available(iOS 11.0, *)
    public var smartQuotesType: UITextSmartQuotesType = .no
    @available(iOS 11.0, *)
    public var smartDashesType: UITextSmartDashesType = .no
    @available(iOS 11.0, *)
    public var smartInsertDeleteType: UITextSmartInsertDeleteType = .no
    public var returnKeyType: UIReturnKeyType = .done
    
	public var keyboardType: UIKeyboardType = .numberPad
	override open var inputAccessoryView: UIView? {
		let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:320, height:50))
		
		let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		let done: UIBarButtonItem = UIBarButtonItem(title: "Done".localized(ACTranslationKey.button_done), style: UIBarButtonItem.Style.done, target: self, action: #selector(SegmentedTextView.doneButtonAction))
		done.accessibilityIdentifier = "done_button"

        done.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 18)!,
                                     NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                     NSAttributedString.Key.foregroundColor : ACColor.primary], for: .normal)
		
		var items:[UIBarButtonItem] = []
		items.append(flexSpace)
		items.append(done)
		
		doneToolbar.items = items
		doneToolbar.sizeToFit()
		
		
		return doneToolbar
	}
	
	
	override open var canBecomeFirstResponder: Bool {
		return true
	}
	
	@objc func doneButtonAction() {
		if shouldTryNext {
        	surveyInputDelegate?.tryNextPressed()
		}
        resignFirstResponder()
	}
	public var hasText: Bool {
		return _value.count > 0
	}
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		updateValue(newValue: [])
		
		surveyInputDelegate?.didFinishSetup()
		
	}
	
	public func set(length:UInt) {
		
		self.inputStack.removeSubviews()
		for _ in 0 ..< length {
			let segment:TextSegment = .get()
			self.inputStack.addArrangedSubview(segment)
		}
		self.updateValue(newValue: _value)
	}
	public func insert(spaceAtIndex index:UInt, ofSize size:CGFloat) {
		guard index < self.inputStack.arrangedSubviews.count else {
			return
		}
		let view = self.inputStack.arrangedSubviews[Int(index)]
		self.inputStack.setCustomSpacing(size, after:view)
	}
	public func insertText(_ text: String) {
        if text == "\n" {
            self.doneButtonAction()
            return
        }
		if _value.count < inputStack.arrangedSubviews.count {
			_value.append(text)
		}
	}
	
	public func deleteBackward() {
		if hasText {
			_value.removeLast()
		}
	}
    
    func openKeyboard() {
        becomeFirstResponder()
    }
	
	
	
	
	public func setValue(_ value: QuestionResponse?) {
		_value = []
		if var buffer = value?.value as? String {
			while buffer.count > 0 && _value.count < inputStack.arrangedSubviews.count{
				_value.insert("\(buffer.removeLast())", at: 0)
			}
		}
	}
	
	private func updateValue(newValue:[String]) {
		let higlightedIndex = newValue.count
		let filledIndex:Int = (higlightedIndex > -1) ? higlightedIndex : -1
		var index = 0
		for view in self.inputStack.arrangedSubviews {
			
			let view = view as! BorderedView
			
			let child = view.subviews.first as! UILabel
			UIView.animate(withDuration: 0.35, animations: {
				
				if index == higlightedIndex {
					view.borderThickness = 3
				} else {
					view.borderThickness = 1
				}
				
				if index <= filledIndex {
					view.borderColor = ACColor.primary
				} else {
					view.borderColor = UIColor.lightGray
					
				}
			})
			if index >= self._value.count {
				child.text = " "
			} else {
				child.text = newValue[index]
			}
			index += 1
			view.layoutSubviews()
		}
		surveyInputDelegate?.didChangeValue()
	}
	
	public func getValue() -> QuestionResponse? {
        if _value.count < inputStack.arrangedSubviews.count {
            return AnyResponse(type: .segmentedText, value: nil)
        }
		return AnyResponse(type: .segmentedText, value: _value.joined())
	}
	override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		becomeFirstResponder()
	}
	
	public func additionalContentViews(for view: UIView) -> Bool {
		if let stack = view as? UIStackView {
			stack.alignment = .leading
		}
		problemsButton = view.button {
			$0.isHidden = true
			$0.titleLabel?.textAlignment = .left
			$0.setTitle("".localized(ACTranslationKey.login_problems_linked).replacingOccurrences(of: "*", with: ""), for: .normal)
			$0.addAction {
				Arc.shared.appNavigation.navigate(state: Arc.shared.appNavigation.defaultContact(), direction: .toRight)
			}
			Roboto.Style.bodyBold($0.titleLabel!, color: .primary)
			$0.setTitleColor(.primary, for: .normal)

			Roboto.PostProcess.link($0)

		}
		return true
	}
    
	public func supplementaryViews(for view: UIView) {
		let nav = Arc.shared.appNavigation
		
		view.privacyStack {
			$0.button.addAction {
				nav.defaultPrivacy()
			}
		}
	}
	
	
	public func setError(message: String?) {
        var borderColor = ACColor.primary
        if message != nil {
            borderColor = ACColor.error
			problemsButton?.isHidden = hideHelpButton
			resignFirstResponder()
		} else {
			problemsButton?.isHidden = true
		}
        for view in inputStack.arrangedSubviews {
            if let v = view as? BorderedView {
                v.borderColor = borderColor
                v.layoutSubviews()
            }
        }
    }
	
//	public func text(in range: UITextRange) -> String? {
//		<#code#>
//	}
//	
//	public func replace(_ range: UITextRange, withText text: String) {
//		<#code#>
//	}
//	
//	public var selectedTextRange: UITextRange?
//	
//	public var markedTextRange: UITextRange?
//	
//	public var markedTextStyle: [NSAttributedString.Key : Any]?
//	
//	public func setMarkedText(_ markedText: String?, selectedRange: NSRange) {
//		<#code#>
//	}
//	
//	public func unmarkText() {
//		<#code#>
//	}
//	
//	public var beginningOfDocument: UITextPosition
//	
//	public var endOfDocument: UITextPosition
//	
//	public func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? {
//		<#code#>
//	}
//	
//	public func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
//		<#code#>
//	}
//	
//	public func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? {
//		<#code#>
//	}
//	
//	public func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult {
//		<#code#>
//	}
//	
//	public func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int {
//		<#code#>
//	}
//	
//	public var inputDelegate: UITextInputDelegate?
//	
//	public var tokenizer: UITextInputTokenizer
//	
//	public func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? {
//		<#code#>
//	}
//	
//	public func characterRange(byExtending position: UITextPosition, in direction: UITextLayoutDirection) -> UITextRange? {
//		<#code#>
//	}
//	
//	public func baseWritingDirection(for position: UITextPosition, in direction: UITextStorageDirection) -> UITextWritingDirection {
//		<#code#>
//	}
//	
//	public func setBaseWritingDirection(_ writingDirection: UITextWritingDirection, for range: UITextRange) {
//		<#code#>
//	}
//	
//	public func firstRect(for range: UITextRange) -> CGRect {
//		<#code#>
//	}
//	
//	public func caretRect(for position: UITextPosition) -> CGRect {
//		<#code#>
//	}
//	
//	public func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
//		<#code#>
//	}
//	
//	public func closestPosition(to point: CGPoint) -> UITextPosition? {
//		<#code#>
//	}
//	
//	public func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? {
//		<#code#>
//	}
//	
//	public func characterRange(at point: CGPoint) -> UITextRange? {
//		<#code#>
//	}
	
}
