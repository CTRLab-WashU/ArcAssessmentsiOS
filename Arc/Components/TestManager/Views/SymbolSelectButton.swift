//
//  SymbolSelectButton.swift
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

open class SymbolSelectButton: UIButton {
    
    var touchLocation:CGPoint?;
    var touchTime:Date?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        //self.layer.borderColor = UIColor(white: 128.0/255.0, alpha: 1.0).cgColor;
        //self.layer.borderWidth = 2;
        //self.layer.cornerRadius = 6;
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.layer.borderColor = ACColor.primary.cgColor
        
//        UIView.animate(withDuration: 0.01, animations: {
//            self.superview?.frame = CGRect(x: (self.superview?.frame.origin.x)!, y: (self.superview?.frame.origin.y)! + 2, width: (self.superview?.frame.size.width)!, height: (self.superview?.frame.size.height)!)
//        })
		
        if let t = touches.first
        {
            touchLocation = t.location(in: self.window);
            touchTime = Date();
        }
		super.touchesBegan(touches, with: event)
		
        //self.sendActions(for: UIControl.Event.touchDown);
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event )
        self.superview?.layer.borderColor = UIColor(white: 128.0/255.0, alpha: 1.0).cgColor
    
//        UIView.animate(withDuration: 0.01, animations: {
//            self.superview?.frame = CGRect(x: (self.superview?.frame.origin.x)!, y: (self.superview?.frame.origin.y)! - 2, width: (self.superview?.frame.size.width)!, height: (self.superview?.frame.size.height)!)
//        })
    }
   
    
}

open class SymbolContainer: UIView {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor(white: 128.0/255.0, alpha: 1.0).cgColor;
        self.layer.borderWidth = 2;
        self.layer.cornerRadius = 6;
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if shadowOpacity > 0.0 {
            self.addShadow()
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
	
	
    // From JAView in joann_ios
    // And https://stackoverflow.com/questions/15704163/draw-shadow-only-from-3-sides-of-uiview
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0),
                   shadowOpacity: Float = 0.2,
                   shadowRadius: CGFloat = 3.0) {
        //Remove previous shadow views
        //superview?.viewWithTag(119900)?.removeFromSuperview()
        
        //Create new shadow view with frame
        let shadowView = UIView(frame: frame)
        //shadowView.tag = 119900
        shadowView.layer.shadowColor = shadowColor
        shadowView.layer.shadowOffset = shadowOffset
        shadowView.layer.masksToBounds = false
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = shadowView.frame.width
        let viewHeight = shadowView.frame.height
        
        // Only add to the bottom
        let top = false
//        let bottom = true
        let left = false
        let right = false
        
        if (!top) {
            y+=(shadowRadius+1)
        }
//        if (!bottom) {
//            viewHeight-=(shadowRadius+1)
//        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
    
        shadowView.layer.shadowOpacity = shadowOpacity
        shadowView.layer.shadowRadius = shadowRadius
        //shadowView.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        shadowView.layer.shadowPath = path.cgPath
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        shadowView.layer.shouldRasterize = true
        insertSubview(shadowView, belowSubview: self)
    }
}





