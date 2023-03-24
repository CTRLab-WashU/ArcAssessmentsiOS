//
//  TimeView.swift
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


open class TimeView: UIView, SurveyInput {
	public weak var surveyInputDelegate: SurveyInputDelegate?

    public var orientation: UIStackView.Alignment = .top
    

    @IBOutlet weak var parentStack: UIStackView!
    @IBOutlet weak var picker:UIDatePicker!
    
    let calendar = Calendar.current
    
    private let dateFormatter:DateFormatter = DateFormatter()
    
    private var _value:String?
	
	public weak var hint:HintView?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
		
        self.dateFormatter.dateFormat = "h:mm a"

        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }

        if let date = self.dateFormatter.date(from: "12:00 PM") {
            picker.setDate(date, animated: false)
        }
		surveyInputDelegate?.didFinishSetup()
        
        if Arc.get(flag: .time_picker_hint_shown) == false {
            let stackTop = parentStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 62)
            stackTop.isActive = true
            
            self.hint = hint {
                $0.content = "".localized(ACTranslationKey.popup_scroll)
                $0.configure(with: IndicatorView.Config(primaryColor: ACColor.hintFill,
                                                        secondaryColor: ACColor.hintFill,
                                                        textColor: .black,
                                                        cornerRadius: 8.0,
                                                        arrowEnabled: true,
                                                        arrowAbove: false))
                $0.updateHintContainerMargins()
                $0.updateTitleStackMargins()
                $0.layout {
                    $0.bottom == picker.topAnchor
                    $0.centerX == picker.centerXAnchor
                    $0.width >= 232
                    $0.height >= 68
                    $0.width <= self.widthAnchor
                    
                }
            }
        }
    }
 
    public func getValue() -> QuestionResponse? {
		
        let value = self.dateFormatter.string(from: picker.date)

        return AnyResponse(type: .time, value: value)
    }
    
    public func setValue(_ value: QuestionResponse?) {
		
		guard let value = value?.value as? String else {
			return
		}
		guard let date = dateFormatter.date(from: value) else {
			return
		}
		picker.date = date

    }
    
    @IBAction func valueChanged(_ sender: Any) {
        // Hide the hint after the first TimeView
        // The value must change to advance past the first TimeView, so this is safe
        Arc.set(flag: .time_picker_hint_shown)
        
        self.surveyInputDelegate?.didChangeValue();
    }
    
    //MARK: TextFields
	
	
	public func setError(message: String?) {
		if message != nil {
			
			
		} else {
			
			
		}
	}
}
