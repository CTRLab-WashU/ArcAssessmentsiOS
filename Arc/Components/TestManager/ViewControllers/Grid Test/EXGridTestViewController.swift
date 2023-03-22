//
//  EXGridTestViewController.swift
//  HASD
//
//  Created by Philip Hayes on 3/12/19.
//  Copyright © 2019 healthyMedium. All rights reserved.
//

import Arc
import UIKit

open class CRGridTestViewController : GridTestViewController {
    override open func displayReady()
    {
        
        guard isVisible else {
            return
        }
        
        Arc.shared.displayAlert(message: "Next: Tap on the locations of the items.".localized("grids_popup2"), options: [
			.wait(waitTime: 2.0, {
			
				$0.set(message:"Ready".localized("grids_popup1"))
		}),
		.wait(waitTime: 4.0, {
			[weak self] in
			self?.displayGrid()
			if let s = self {
				s.tapOnTheFsLabel.isHidden = true
			}
			$0.removeFromSuperview()
		})])
		
		
       
        
        
    }
}
