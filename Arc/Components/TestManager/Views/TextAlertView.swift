//
//  TextAlertView.swift
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

open class TextAlertView: UIView {
    
    var timeout:TimeInterval?;
    var timeoutTimer:Timer?;
    
    var onConfirm : (() -> Void)?
    
    @IBOutlet weak var textLabel: UILabel!
    private var message:String?
    @IBOutlet weak var okayButton: UIButton!
    private var confirmString:String?
    var timein:TimeInterval?;
    
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if (message != nil) {
            setText(string: message!)
        }
        
        if confirmString != nil
        {
            okayButton.setTitle(confirmString, for: .normal);
        }
        
        if let t = timein
        {
            okayButton.isEnabled = false;
            
            Timer.scheduledTimer(timeInterval: t, target: self, selector: #selector(self.enableOkayButton), userInfo: nil, repeats: false);
        }
        if let t = timeout
        {
            timeoutTimer = Timer.scheduledTimer(timeInterval: t, target: self, selector: #selector(self.confirmationButtonPresssed), userInfo: nil, repeats: false);
        }
//        textLabel.superview?.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background_light_16x16"))
    }
    
    public func setText(string:String){
        
        if textLabel == nil {
            message = string
            
        } else {
            textLabel.text = string
            
            
        }
        
    }
    @objc func confirmationButtonPresssed() {
        self.timeoutTimer?.invalidate();
        onConfirm?()
        self.removeFromSuperview()
    }
    
    
    public func setConfirmText(string:String)
    {
        if okayButton != nil {
//            okayButton.translationKey = nil
            
        }
        confirmString = string;
        if okayButton != nil
        {
            okayButton.setTitle(confirmString, for: .normal);
        }
    }
    @IBAction func confirm(_ sender: AnyObject) {
        confirmationButtonPresssed()
    }
    
    @objc func enableOkayButton()
    {
        self.okayButton.isEnabled = true;
    }
}
