//
//  ChoiceView.swift
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

@IBDesignable open class ChoiceView : UIView {
    public enum State {
        case radio, checkBox, button
        
        fileprivate var unselectedImage:UIImage? {
            get {
                switch self {
                case .checkBox:
                    return Arc.shared.image(named: "cut-ups/checkbox/unselected")
                case .button:
                    return nil
                default:
                    return Arc.shared.image(named: "cut-ups/radio/unselected")
                }
            }
        }
        
        fileprivate var selectedImage:UIImage? {
            get {
                switch self {
                case .checkBox:
                    return Arc.shared.image(named: "cut-ups/checkbox/selected")
                case .button:
                    return nil
                default:
                    //return Arc.shared.image(named: "cut-ups/radio/selected")
                    return Arc.shared.image(named: "cut-ups/radio/selected alt")
                }
            }
        }
		fileprivate func cornerRadius(referenceHeight:CGFloat = 22.0)->CGFloat {
			switch self {
			case .checkBox:
				return 6.0
			default:
				return referenceHeight
			}
        }
//        var altSelectedImage:UIImage? {
//            get {
//                switch self {
//                case .checkBox:
//                    return nil
//                default:
//                    return Arc.shared.image(named: "cut-ups/radio/selected alt")
//                }
//            }
//        }
        
    }
    public var didFinishSetup: (() -> ())?

    override open func awakeFromNib() {
        self.wrappedView.layer.cornerRadius = 6.0
        self.button.isUserInteractionEnabled = false
        self.wrappedView.isUserInteractionEnabled = false
    }
    
    @IBOutlet weak var wrappedView: ACView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var mainButton: UIButton!

    @IBOutlet weak var label: UILabel!
	var isExclusive:Bool = false
    var needsImmediateResponse:Bool = false
    private var _isSelected = false
	private var _state:State?
    var tapped:((ChoiceView)->Void)?
    
    func getMessage() -> String? {
        return label.text
    }
    func getSelected() -> Bool {
        return _isSelected
    }
    func set(message:String?) {
		
        label.text = message?.localized(message ?? "")
    }
    
    func set(selected:Bool, shouldUpdateColors:Bool=true) {
        _isSelected = selected
        if shouldUpdateColors {
            updateColors()
        }
    }
    func set(state:State) {
		_state = state
        button.setImage(state.unselectedImage, for: .normal)
        button.setImage(state.selectedImage, for: .selected)
		self.wrappedView.cornerRadius = state.cornerRadius(referenceHeight: self.frame.height/2)
        if state == .button {
            label.textAlignment = .center
            button.isHidden = true
        }
    }
    @IBAction func tapped(_ sender: Any) {
        //tapped?(self)
		
    }
    
    func updateColors() {
        self.button.isSelected = _isSelected
        self.wrappedView.backgroundColor = (_isSelected) ? ACColor.primarySectionBackground : nil
        self.wrappedView.borderColor = (_isSelected) ? ACColor.primary : ACColor.primarySelected
        self.wrappedView.borderThickness = (_isSelected) ? 2.0 : 1.0
        if (_isSelected) {
            label.font = UIFont(name: "Roboto-Black", size: 18)
        } else {
            label.font = UIFont(name: "Roboto-Medium", size: 18)
        }
        self.layoutSubviews()

    }
//
	open override func layoutSubviews() {
		super.layoutSubviews()
		self.wrappedView.cornerRadius = _state?.cornerRadius(referenceHeight: self.wrappedView.frame.height/2) ?? 22.0

	}
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if (needsImmediateResponse == true) {
            tapped?(self)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let location = touches.first?.location(in: self) else { return }
        if (location.x < 0)
            || (location.y < 0)
            || (location.x > self.frame.width)
            || (location.y > self.frame.height)
        {
            updateColors()
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if (needsImmediateResponse == true) {
            updateColors()
        } else {
            tapped?(self)
        }
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        updateColors()
    }
    
}
