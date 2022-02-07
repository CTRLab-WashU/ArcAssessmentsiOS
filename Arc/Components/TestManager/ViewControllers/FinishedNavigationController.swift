//
//  FinishedNavigationController.swift
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

open class FinishedNavigationController: BasicSurveyViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
		//self.isNavigationBarHidden = true
        shouldShowHelpButton = false
        displayHelpButton(shouldShowHelpButton)
        shouldShowBackButton = true
        displayBackButton(shouldShowBackButton)
        // Do any additional setup after loading the view.
		guard let session = Arc.shared.currentTestSession else {return}
		guard let study = Arc.shared.currentStudy else {return}

        // TODO: mdephillips 2/3/22 Deprecated code for context, remove when new library is complete
//        Arc.shared.studyController.mark(finished: session, studyId: study)

    }
	
	
	//Override this to write to other controllers
	override open func valueSelected(value:QuestionResponse, index:String) {
        
		guard let session = Arc.shared.currentTestSession else {return}
		guard let study = Arc.shared.currentStudy else {return}
        guard let v = value.value as? Int else {
            return
        }
		
        // TODO: mdephillips 2/3/22 Deprecated code for context, remove when new library is complete
//		if v == 0 {
//			Arc.shared.studyController.mark(interrupted:true, sessionId: session, studyId: study)
//		} else if v == 1 {
//			Arc.shared.studyController.mark(interrupted:false, sessionId: session, studyId: study)
//
//		}
		//Arc.shared.currentTestSession = nil
		
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
