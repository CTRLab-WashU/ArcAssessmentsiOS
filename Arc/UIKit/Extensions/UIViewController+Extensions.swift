//
//  UIViewController+Extensions.swift
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

public extension UIViewController {
	
	static func get<T:UIViewController>(nib:String? = nil, bundle:Bundle? = nil) -> T {
		var _bundle:Bundle? = bundle
		if bundle == nil {
            _bundle = Bundle.module

		}
        let vc = T(nibName: nib ?? String(describing: self), bundle: _bundle)
        
        return vc
    }
    
    static func instanceFromType(_ type:UIViewController.Type, nib:String? = nil, bundle:Bundle? = nil) -> UIViewController {
        //For multi-module functionality.
        var _bundle:Bundle? = bundle
        if bundle == nil {
            _bundle = Bundle.module
            
        }
        let vc = type.init(nibName: nib ?? String(describing: self), bundle: _bundle)
        
        return vc
    }
    
	static func present<T:UIViewController>(nib:String? = nil, onSetup:((T)->Void)? = nil, onCompletion:(()->Void)? = nil) -> T {
        
        let vc:T = .get()
        
        onSetup?(vc)
        
        let window = UIApplication.keyWindow()?.rootViewController
        
        window?.present(vc, animated: true, completion: {
            
            onCompletion?()
            
        })
        
        return vc
    }
    static func replace<T:UIViewController>(nib:String? = nil, onSetup:((T)->Void)? = nil, onCompletion:((T)->Void)? = nil) -> T {
        
        let vc:T = .get()
        
        onSetup?(vc)
        
        UIApplication.keyWindow()?.rootViewController = vc
        UIApplication.keyWindow()?.makeKeyAndVisible()
        
        onCompletion?(vc)
        return vc
    }
}
