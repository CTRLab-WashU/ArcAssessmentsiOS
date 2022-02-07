//
//  SurveyInputView.swift
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
public protocol SurveyInputDelegate : class {
	func nextPressed(input:SurveyInput?, value:QuestionResponse?)
	func templateForQuestion(id:String)-> Dictionary<String, String>
	
	func didFinishSetup()
	func didChangeValue()
	func tryNextPressed()
}
public protocol SurveyInput {
    ///Returns nil if the value returned is invalid
    func getValue() -> QuestionResponse?
    func isInformational() -> Bool
    func setValue(_ value:QuestionResponse?)
	func setError(message:String?)
	func supplementaryViews(for view:UIView)
	func additionalContentViews(for view:UIView) -> Bool

	var orientation:UIStackView.Alignment {get set}
    var distribution:UIStackView.Distribution {get set}
	var surveyInputDelegate:SurveyInputDelegate? {get set}
    var isBottomAnchored:Bool {get}
    var parentScrollView:UIScrollView? {get set}
    
}

extension SurveyInput {
    public var parentScrollView:UIScrollView? {
        get {
            return nil
        }
        set {
            
        }
    }

    public var isBottomAnchored:Bool {
        return false
    }
    public var distribution:UIStackView.Distribution {
        get {
            return .fill
        }
        set {
            
        }
    }
    public func isInformational() -> Bool {
        return false
    }
	public func setError(message: String?) {
		
	}
	
	public func supplementaryViews(for view:UIView) {
		
	}
	public func additionalContentViews(for view:UIView) -> Bool {
		return false
	}

    func setValues(_ values:[String]?) {
        
    }
	
	func getInputAccessoryView(selector:Selector) -> UIToolbar{
		let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:320, height:50))
		
		let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		let done: UIBarButtonItem = UIBarButtonItem(title: "Done".localized(ACTranslationKey.button_done), style: UIBarButtonItem.Style.done, target: self, action: selector)
		done.accessibilityIdentifier = "done_button"
		done.isAccessibilityElement = true
        done.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 18)!,
                                     NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                     NSAttributedString.Key.foregroundColor : UIColor(named:"Primary")!], for: .normal)

		
		var items:[UIBarButtonItem] = []
		items.append(flexSpace)
		items.append(done)
		
		doneToolbar.items = items
		doneToolbar.sizeToFit()
		return doneToolbar
	}
    
}

