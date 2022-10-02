//
//  QuestionType.swift
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

import Foundation
import UIKit

public enum QuestionType : String, Codable {
	case none, text, number, slider, choice, checkbox, time, duration, password, segmentedText, multilineText, image, calendar, picker, signature
	
	public var metatype: Codable.Type {
		switch self {
		case .none, .text, .time, .duration, .password, .segmentedText, .multilineText, .number, .image,  .calendar, .signature:
			return String.self
			
		case .slider:
			return Float.self
		case .choice, .picker:
			return Int.self
			
		case .checkbox:
			return [Int].self
		}
	
	}
	func create(inputWithQuestion question:Survey.Question?) -> SurveyInput? {
		var input:SurveyInput?
		
		switch self {
		case .none:
			break
	
		case .slider:
			let inputView:SliderView = .get()
			guard let question = question else {
				return nil
			}
			inputView.set(min: question.minValue ?? 0,
						  max: question.maxValue ?? 100,
						  minMessage: question.minMessage ?? "",
						  maxMessage: question.maxMessage ?? "")
			
			input = inputView
			

			
		case  .time:
			let inputView:TimeView = .get()
			
			input = inputView
			
		
		case .duration:
			let inputView:DurationView = .get()
		
			input = inputView
		
		
		case .choice:
			let inputView:MultipleChoiceView = .get()
			input = inputView
			guard let question = question else {
				return nil
			}
			inputView.set(question:question)
		
		
		
		case .checkbox:
			let inputView:MultipleChoiceView = .get()
			input = inputView
			inputView.state = .checkBox
			guard let question = question else {
				return nil
			}
			inputView.set(question:question)
		
		
		
		case .password:
			let inputView:PasswordView = .get()
			inputView.openKeyboard()
			input = inputView
		
		case .segmentedText:
			let inputView:SegmentedTextView =  .get()
			inputView.openKeyboard()
			input = inputView
		
		case .text, .multilineText:
			let inputView:MultilineTextView = .get()
			input = inputView
			inputView.minCharacters = 1
		
		
		
		case .number:
			let inputView:MultilineTextView = .get()
			input = inputView
			inputView.maxCharacters = 2
			inputView.minCharacters = 1
			inputView.keyboardType = .numberPad
            inputView.textView.reloadInputViews()
		
		case .image:
			let inputView:SignatureView =  .get()
			input = inputView
		
		
		case .calendar:
			let inputView:ACCalendarView =  ACCalendarView(frame: .zero)
			input = inputView
		
		case .picker:
			let inputView:ACPickerView = .get()
		
			input = inputView
		
		
	
		case .signature:
			let inputView:SignatureView = .get()
			
			input = inputView
		}
		return input

	}
}

