//
//  PrivacyStack.swift
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




public class PrivacyStack: UIView {
	weak var button:UIButton!
	public init() {
		super.init(frame: .zero)
		
		stack { [weak self] in
			$0.axis = .vertical
			$0.alignment = .center
			$0.acLabel {
				$0.textAlignment = .center
				$0.text = "By signing in you agree to our"
					.localized(ACTranslationKey.bysigning_key)
				$0.numberOfLines = 0
				
			}
			
            let attributes:[NSAttributedString.Key:Any] = [
                .foregroundColor : ACColor.primary as Any,
                .font : UIFont(name: "Roboto-Bold", size: 16.0) as Any,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            let privacyTitle = NSAttributedString(string: "Privacy Policy".localized(ACTranslationKey.privacy_linked), attributes: attributes)
            
			self?.button = $0.button {
                $0.setAttributedTitle(privacyTitle, for: .normal)
                $0.setTitle("Privacy Policy".localized(ACTranslationKey.privacy_linked),
                            for: .normal)
                $0.setTitleColor(ACColor.primary, for: .normal)
                Roboto.PostProcess.link($0)
			}
		}
		.layout { [weak self] in
			guard let weakSelf = self else {
				return
			}
			$0.top == weakSelf.topAnchor ~ 999
			$0.trailing == weakSelf.trailingAnchor ~ 999
			$0.bottom == weakSelf.bottomAnchor ~ 999
			$0.leading == weakSelf.leadingAnchor ~ 999
			$0.width == weakSelf.widthAnchor ~ 999
			$0.height == weakSelf.heightAnchor ~ 999
		}
	}
	
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


extension UIView {
	
	@discardableResult
	public func privacyStack(apply closure: (PrivacyStack) -> Void) -> PrivacyStack {
		return custom(PrivacyStack(), apply: closure)
	}
	
}
