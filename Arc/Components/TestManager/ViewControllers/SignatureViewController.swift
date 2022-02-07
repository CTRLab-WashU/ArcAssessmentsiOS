//
//  SignatureViewController.swift
//  ARC
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

class SignatureViewController: UIViewController, SignatureViewDelegate  {
    @IBOutlet weak var signatureView:SignatureView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        

        self.signatureView.signatureDelegate = self
        self.signatureViewContentChanged(state: .empty)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func undo(sender:UIButton){
        self.signatureView.clear()
    }
    @IBAction func pressedNext(sender: UIButton)
    {
        //TODO: save signature
        if signatureView.path.isEmpty {
            return
        }
        if (signatureView.save()?.pngData()) != nil
        {
           
            
           
        }
    }
    
    func signatureViewContentChanged(state: SignatureViewContentState) {
        let btns = [self.view.viewWithTag(1) as! UIButton,self.view.viewWithTag(2) as! UIButton]
        
        switch  state {
            
        case .empty:
            
            for b in btns {
                b.alpha = 0.5
                b.isEnabled = false
            }
        case .dirty:
            for b in btns {
                
                b.alpha = 1
                b.isEnabled = true
            }
            
        }
        
        
    }
    
}
