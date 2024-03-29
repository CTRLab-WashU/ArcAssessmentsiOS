//
//  SliderView.swift
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

open class SliderView: UIView, SurveyInput {
    public var didFinishSetup: (() -> ())?
    
    public var orientation: UIStackView.Alignment = .bottom
    public var isBottomAnchored:Bool {
        return true
    }
    
    @IBOutlet weak var selectedContainer: UIStackView!
    
    @IBOutlet weak var valueLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!

    @IBOutlet weak var sliderContainer: BorderedUIView!
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    public var didChangeValue: (() -> ())?
	public var tryNext:(() -> ())?
	public weak var surveyInputDelegate: SurveyInputDelegate?
	public weak var hint:HintView?
    var first = true
	var hideSelectedAfterFirst = false
    //Setting this will override all future instances created
    static public var hideSelection:Bool?
    private var _value:Float? = nil
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	open override func awakeFromNib() {
		super.awakeFromNib()
		updateText(nil)
		surveyInputDelegate?.didFinishSetup()
        if Arc.get(flag: .slider_hint_shown) == false {
            self.hint = hint {
                $0.content = "".localized(ACTranslationKey.popup_drag)
                $0.configure(with: IndicatorView.Config(primaryColor: ACColor.hintFill,
                                                        secondaryColor: ACColor.hintFill,
                                                        textColor: .black,
                                                        cornerRadius: 8.0,
                                                        arrowEnabled: true,
                                                        arrowAbove: false))
                $0.updateHintContainerMargins()
                $0.updateTitleStackMargins()
                $0.layout {
                    $0.bottom == valueSlider.topAnchor - 32
                    $0.centerX == valueSlider.centerXAnchor
                    $0.width >= 232
                    $0.height >= 68
                    $0.width <= self.widthAnchor
                    
                }
            }
        }
	}
	public func setHidesSelectedAfterFirst(value:Bool) {
		hideSelectedAfterFirst = value
	}
    public func hideSelectedContainer() {
		//Prevents layout change when toggled off
        selectedContainer.alpha = 0
		self.hint?.removeFromSuperview()
    }
    
    public func getValue() -> QuestionResponse? {
		guard let value = _value else {
			return AnyResponse(type: .slider, value: nil)
		}
		let res = AnyResponse(type: .slider, value: ((value)/valueSlider.maximumValue))
        return res
    }
    public func setValue(_ value: QuestionResponse?) {
		
        defer {
            updateText(_value)            
        }
		
		if let value = value?.value as? Float {
            first = false
			_value = value * valueSlider.maximumValue
			valueSlider.value = value * valueSlider.maximumValue
            if SliderView.hideSelection ?? hideSelectedAfterFirst {
                hideSelectedContainer()
            }
		} else {
			_value = nil
			valueSlider.value = valueSlider.maximumValue / 2
            
		}
		

    }
    private func updateText(_ value:Float?) {
        
        guard let value = value else {
            valueLabel.text = ""
            detailLabel.text = "Drag to select".localized(ACTranslationKey.popup_drag)
            return
        }
		detailLabel.text = "You've selected:"
        valueLabel.text = "\(Int(value))"
    }
    func set(min:Float, max:Float, minMessage:String?, maxMessage:String?) {
        valueSlider.minimumValue = min
        valueSlider.maximumValue = max
        valueSlider.value = max / 2
        valueSlider.setThumbImage(Arc.shared.image(named: "cut-ups/slider/static"), for: .normal)
        valueSlider.setThumbImage(Arc.shared.image(named: "cut-ups/slider/pressed"), for: .highlighted)
        //sliderContainer.clipsToBounds = false
        //self.bringSubviewToFront(valueSlider)
        valueSlider.layer.zPosition = 10000
		if  let value = _value {
			valueLabel.text = "\(value)"

		}

        minLabel.text = minMessage?.localized(minMessage ?? "")
        maxLabel.text = maxMessage?.localized(maxMessage ?? "")
        
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
		
        Arc.set(flag: .slider_hint_shown)
        
        if !first {
            _value = sender.value
			
            if SliderView.hideSelection ?? hideSelectedAfterFirst {
				hideSelectedContainer()
			}
            surveyInputDelegate?.didChangeValue()
		} else {
			
		}
		
        first = false
        updateText(_value)

    }
    
    @IBAction func touched(_ sender: Any) {
        
    }
    @IBAction func released(_ sender: Any) {
        
    }
}
