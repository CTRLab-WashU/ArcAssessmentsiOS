//
//  SignatureViewController.swift
//  CRI
//
//  Created by Philip Hayes on 3/5/19.
//  Copyright © 2019 healthyMedium. All rights reserved.
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
        

        self.signatureView.delegate = self
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
        if let img = signatureView.save()?.pngData()
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
