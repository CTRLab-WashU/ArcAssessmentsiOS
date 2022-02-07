//
//  MultipleChoiceView.swift
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
open class MultipleChoiceView : UIView,  SurveyInput {
	public weak var surveyInputDelegate: SurveyInputDelegate?

	
    public var orientation: UIStackView.Alignment = .top


    @IBOutlet var stack:UIStackView!
    
    
	
    private var views:[ChoiceView] = []
    
    var state:ChoiceView.State = .radio
    
    public func set(question:Survey.Question) {
        guard let answers = question.answers else {
            return
        }
        
        stack.removeSubviews()
		views.removeAll()
        for option in answers {
			let message = String(describing: option.value as! String)
			
            let o:ChoiceView = .get()
			o.mainButton.accessibilityIdentifier = "choice_\(views.count)"
            o.set(message: message)
            o.set(state: state)
			o.isExclusive = option.exclusive ?? false
			
            o.tapped = {
                [weak self] view in
                self?.selectView(view: view)
            }
            views.append(o)
            stack.addArrangedSubview(o)
        }
		surveyInputDelegate?.didFinishSetup()
    }
    
    private func selectView(view:ChoiceView) {
        if state == .radio  || view.isExclusive {
            for v in views {
                v.set(selected: false)
            }
            view.set(selected: true)
        } else {
			
			for v in views {
				if v.isExclusive {
					v.set(selected: false)
				}
			}
            view.set(selected: !view.getSelected())

        }
        surveyInputDelegate?.didChangeValue()
    }

    public func getValue() -> QuestionResponse? {
		var selected = [Int]()
		var options:[String] = []

		for (index, v) in views.enumerated() {
			
			if v.getSelected() {
				selected.append(index)
				guard let message = v.getMessage() else {
					fatalError("The answer value is missing, check json.")
				}
				options.append(message)
			}
		}
		switch state {
		case .checkBox:
			if options.count == 0 {
				return nil //AnyResponse(type: .checkbox, value: selected, textValue: nil)

			}
			return AnyResponse(type: .checkbox, value: selected, textValue: options.joined(separator: ","))

		case .radio, .button:
			return AnyResponse(type: .choice, value: selected.first, textValue: options.first)

		}
    }
    
    public func setValue(_ value: QuestionResponse?) {
        //didChangeValue?()
        if value?.type == .choice {
            let value = value?.value as? Int
            
            if let selected = value {
                views[selected].set(selected: true)
            }
        } else {
            let value = value?.value as? [Int] ?? []
            
            let selected = value
            
            for (index, v) in views.enumerated() {
                v.set(selected: selected.contains(index))
            }
        }
        
//        didChangeValue?()
    }
    func setValues(_ values:[String]?) {
        
    }
	
}
