//
//  GridTestCells.swift
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


open class GridImageCell:UICollectionViewCell
{
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var dotView: BorderedView!
    var isPracticeCell:Bool = false
    var touchLocation:CGPoint?
    var touchTime:Date?
    func setImage(image:UIImage?){
        
        self.image.image = image
        self.image.backgroundColor = .clear
    }
    
    override open var isSelected: Bool {
        willSet {
            if newValue == true
            {
                if Arc.environment?.gridTestType == .extended {
                    self.backgroundColor = ACColor.secondary
                    self.layer.borderWidth = 5
                    self.layer.borderColor = ACColor.primary.cgColor
                } else {
                    self.image.isHidden = true
                    self.backgroundColor = UIColor(red:0, green:0.37, blue:0.52, alpha:1) //UIColor(red: 13.0 / 255.0, green: 143.0 / 255.0, blue: 192.0 / 255.0, alpha: 1.0);
                }
                
                if isPracticeCell {
                    if Arc.environment?.gridTestType == .extended {
                        touchTime = Date()
                    } else {
                        self.dotView.isHidden = false
                    }
                }
            }
            else
            {
                if Arc.environment?.gridTestType == .extended {
                    self.layer.borderWidth = 1
                    self.layer.borderColor = UIColor(red: 133.0/255.0, green: 141/255.0, blue: 145.0/255.0, alpha: 1.0).cgColor
                } else {
                    self.dotView.isHidden = true
                }
                self.backgroundColor = UIColor(red: 191.0/255.0, green: 215.0/255.0, blue: 224.0/255.0, alpha: 1.0) //UIColor(red: 182.0/255.0, green: 221.0/255.0, blue: 236.0/255.0, alpha: 1.0);
            }
        }
    }
    
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first
        {
            touchLocation = t.location(in: self.window);
            touchTime = Date();
        }
        
//        if self.isPracticeCell && self.isSelected {
//            return
//        }
        
        super.touchesBegan(touches, with: event)
        super.touchesEnded(touches, with: event);
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override open func prepareForReuse() {
        self.isSelected = false;
        super.prepareForReuse();
    }
    func clear() {
        touchTime = nil;
        touchLocation = nil;
        setImage(image: nil)
        image.isHidden = true;
    }
    
}
open class GridFCell:UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    func setCharacter(character:String){
        label.text = character
    }
    
    override open func prepareForReuse() {
        self.isSelected = false;
        super.prepareForReuse();
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		self.contentView.layer.backgroundColor = UIColor(named:"Primary")!.cgColor
        self.label.textColor = UIColor.white
    }
	open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.contentView.layer.backgroundColor = UIColor(named:"Primary")!.cgColor
		self.label.textColor = UIColor.white
		super.touchesBegan(touches, with: event)
		

	}
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		self.contentView.layer.backgroundColor = UIColor.clear.cgColor
		self.label.textColor = ACColor.primary
		super.touchesEnded(touches, with: event)
		
		
//        self.contentView.layer.backgroundColor = UIColor(red: 191.0/255.0, green: 215.0/255.0, blue: 224.0/255.0, alpha: 1.0).cgColor
//        self.label.textColor = UIColor(red:38.0/255.0, green:94.0/255.0, blue:130.0/255.0, alpha:1)
    }
    
}
