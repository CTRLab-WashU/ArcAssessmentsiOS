//
//  ACPickerView.swift
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

class ACPickerView: UIView, SurveyInput, UIPickerViewDelegate, UIPickerViewDataSource {
   
	public weak var surveyInputDelegate: SurveyInputDelegate?


    public var orientation: UIStackView.Alignment = .top
   
    
    @IBOutlet weak var picker: UIPickerView!
    
    var _question:Survey.Question?
    var _items:[String]?
    let calendar = Calendar.current
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        picker.delegate = self
        picker.dataSource = self
        surveyInputDelegate?.didFinishSetup()

        
    }
    public func set(_ items:[String]) {
        _items = items
        picker.reloadAllComponents()

    }

    
    public func set(question: Survey.Question) {
        _question = question
        picker.reloadAllComponents()
    }
    public func getValue() -> QuestionResponse? {
        
        let selectedIndex = picker.selectedRow(inComponent: 0)
        let selectedTextValue = self.pickerView(picker,
                                                titleForRow: selectedIndex,
                                                forComponent: 0)
        
        return AnyResponse(type: .choice, value: selectedIndex, textValue: selectedTextValue)
    }
    
    public func setValue(_ value: QuestionResponse?) {
        guard let index = value?.value as? Int else {
            return
        }
        picker.selectRow(index, inComponent: 0, animated: true)
    }
    
    
    @IBAction func valueChanged(_ sender: Any) {
        self.surveyInputDelegate?.didChangeValue();
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _question?.answers?.count ?? _items?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _question?.answers?[row].value as? String ?? _items?[row] 
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        surveyInputDelegate?.didChangeValue()
    }
}
