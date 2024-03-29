//
//  TestIntroView.swift
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





public class InfoView: ACTemplateView {
	
	public enum ButtonStyle {
		case primary, secondary
		
		public func configure(button:ACButton) {
			switch self {
			case .primary:
				button.primaryColor = ACColor.primary
				button.secondaryColor = ACColor.primaryGradient
				button.topColor = ACColor.primaryInnerTop
				button.bottomColor = ACColor.primaryInnerBottom
				button.setTitleColor(.white, for: .normal)
			case .secondary:
				button.primaryColor = ACColor.secondary
				button.secondaryColor = ACColor.secondaryGradient
				button.topColor = ACColor.secondaryInnerTop
				button.bottomColor = ACColor.secondaryInnerBottom
				button.setTitleColor(ACColor.badgeText, for: .normal)
			}
			
		}
	}
	
	weak var inputDelegate:SurveyInputDelegate? {
		didSet {
			self.inputItem?.surveyInputDelegate = inputDelegate

		}
	}
	public var infoContent:InfoContentView!
	public var miscContainer:UIStackView!
	public var additionalContent:UIStackView!
	public var inputContainer:UIStackView!
	public var errorLabel:UILabel!
	public var topSpacer:UIView!
	public var inputItem:SurveyInput? {
		didSet {
			self.inputItem?.surveyInputDelegate = inputDelegate
		}
	}
	public func setTextColor(_ color:UIColor?) {
        if let colorUnwrapped = color {
            infoContent.textColor = colorUnwrapped
        }
	}
	public func setButtonColor(primary:UIColor?, secondary:UIColor?, textColor:UIColor) {
		nextButton?.primaryColor = primary!
		nextButton?.secondaryColor = secondary!
		nextButton?.setTitleColor(textColor, for: .normal)
		
	}
	public func setButtonColor(style:ButtonStyle) {
		guard let button = nextButton else {
			return
		}
		style.configure(button: button)
		
	}
    public func enableNextButton(title:String = "NEXT".localized(ACTranslationKey.button_next)) {
        nextButton?.isEnabled = true;
        nextButton?.alpha = 1;
        nextButton?.setTitle(title, for: .normal)
    }
    public func disableNextButton(title:String = "NEXT".localized(ACTranslationKey.button_next)) {
        nextButton?.isEnabled = false;
        nextButton?.alpha = 0.5;
        nextButton?.setTitle(title, for: .normal)
    }
	public func setInput(_ view:(UIView & SurveyInput)?) {
		inputItem = view
		
		inputItem?.parentScrollView = root
		if view?.additionalContentViews(for: self.additionalContent) ?? false {
			self.additionalContent.isHidden = false
		} else {
			if additionalContent.arrangedSubviews.count == 0 {
				self.additionalContent.isHidden = true
			}
		}
		view?.supplementaryViews(for: self.miscContainer)
		if miscContainer.subviews.count > 0 {
			miscContainer.isHidden = false
		}
		inputContainer.removeSubviews()

		if let view = view {
			inputContainer.addArrangedSubview(view)
			inputContainer.alignment = inputItem?.orientation ?? .top
		} else {
			inputContainer.removeSubviews()
		}
	}
	public func setAdditionalContent(_ view:UIView?) {
		if let view = view {
			additionalContent.isHidden = false

			additionalContent.addArrangedSubview(view)
		} else {
			additionalContent.isHidden = true

			additionalContent.removeSubviews()
		}
	}
	public func setAdditionalFooterContent(_ view:UIView?) {
		if let view = view {
			miscContainer.isHidden = false
			miscContainer.addArrangedSubview(view)
			
		} else {
			miscContainer.isHidden = true

			miscContainer.removeSubviews()
		}
	}
	public func setError(message:String?) {
		errorLabel.text = message
		inputItem?.setError(message: message)
		if let _ = message {
			spacerView.isHidden = false
		}
	

	}
	public func setHeading(_ text:String?) {
		infoContent.setHeader(text)
	}
	public func setMediumHeading(_ text:String?) {
		infoContent.setMediumHeader(text)
	}
    public func setIntroHeading(_ text:String?){
        infoContent.setIntroHeader(text)
    }
	public func setSeparatorWidth(_ width:CGFloat) {
		infoContent.setSeparatorWidth(width)
	}
	public func addSpacer() {
		infoContent.addSpacer()
	}
	public func setSubHeading(_ text:String?) {
		infoContent.setSubHeader(text)

	}
    public func setPrompt(_ text:String?){
        infoContent.setPrompt(text)
    }
	public func setContentText(_ text:String?, template:[String:String] = [:]) {
		infoContent.setContent(text, template:template)

	}
    public func setIntroContentText(_ text:String?, template:[String:String] = [:]) {
        infoContent.setIntroContent(text, template:template)

    }
	public func setContentLabel(_ text:String?, template:[String:String] = [:]) {
		infoContent.setContentLabel(text, template:template)
		
	}
    public func getContentLabel() -> HMMarkupLabel {
        return (infoContent?.contentLabel!)!
    }
	override open func content(_ view: UIView) {
		super.content(view)
		
		topSpacer = view.view {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.isHidden = true
			$0.setContentHuggingPriority(UILayoutPriority(200), for: .vertical)
		}
		
		infoContent = view.infoContent {_ in
		
		}
		inputContainer = view.stack {
			$0.axis = .horizontal
			$0.alignment = .top
			$0.spacing = 8

		}
		errorLabel = view.acLabel {
			Roboto.Style.error($0)
		}
		
		//Hide this view when not in use
		additionalContent = view.stack {
			$0.axis = .vertical
			$0.alignment = .fill
			$0.spacing = 20
			$0.isHidden = true
		}

	}
	
	public override func footer(_ view:UIView) {
		super.footer(view)
		view.stack { [weak self] in
			$0.axis = .vertical
			$0.alignment = .fill
			$0.spacing = 8
			
			//Use this container to insert views as seen fit
			self?.miscContainer = $0.stack {
				$0.axis = .vertical
				$0.accessibilityLabel = "Misc Container"
				$0.isLayoutMarginsRelativeArrangement = true
				$0.layoutMargins = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
				$0.isHidden = true
			}
			self?.nextButton = $0.acButton {
				ButtonStyle.secondary.configure(button: $0)
				$0.accessibilityIdentifier = "next_button"
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.setTitle("NEXT".localized(ACTranslationKey.button_next), for: .normal)
				
			}
		}
	}
}
