//
//  ACSignatureNavigationController.swift
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

open class ACSignatureNavigationController: SurveyNavigationViewController {
    public var sessionId:Int64 = -1
    public var tag:Int32 = -1
    open override func viewDidLoad() {
        super.viewDidLoad()
        guard let session = Arc.shared.currentTestSession else {return}
        
        sessionId = Int64(session)
		let backButton = UIButton(type: .custom)
			backButton.frame = CGRect(x: 0, y: 0, width: 60, height: 10)
			backButton.setImage(Arc.shared.image(named: "cut-ups/icons/arrow_left_blue"), for: .normal)
			backButton.setTitle("BACK".localized(ACTranslationKey.button_back), for: .normal)
			backButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 14)
			backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -12)
			backButton.setTitleColor(ACColor.primary, for: .normal)
			backButton.addTarget(self, action: #selector(self.backPressed), for: .touchUpInside)
			
			let leftButton = UIBarButtonItem(customView: backButton)
			
		
		navigationItem.leftBarButtonItem = leftButton
    }
	@objc func backPressed()
	{
	  navigationController?.popViewController(animated: true)
	}
    open override func valueSelected(value: QuestionResponse, index: String) {
        //Do things here
        guard let image = value.value as? UIImage else {
            return
        }
        
        if Arc.shared.appController.save(signature: image, sessionId: sessionId, tag: tag) {
            print("saved")
        } else {
            print("Not saved")
        }
    }

}
