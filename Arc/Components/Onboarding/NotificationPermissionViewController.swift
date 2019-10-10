//
//  NotificationPermissionViewController.swift
//  Arc
//
//  Created by Philip Hayes on 7/12/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import UIKit
import ArcUIKit
public class NotificationPermissionViewController: CustomViewController<NotificationPermissionView>, SurveyInput {
	
	public weak var surveyInputDelegate: SurveyInputDelegate?

	public var orientation: UIStackView.Alignment = .center
	
	
	
	var _didAllow:Bool = false
	
	
	override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

	override public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		Arc.shared.notificationController.authenticateNotifications { [weak self] (granted, error) in
			OperationQueue.main.addOperation {
				self?._didAllow = granted
				Arc.shared.appController.isNotificationAuthorized = granted
				self?.surveyInputDelegate?.didChangeValue()
				self?.surveyInputDelegate?.tryNextPressed()
				
			}
			
		}
		
	}
	
	
	public func getValue() -> QuestionResponse? {
		return AnyResponse(type: .choice, value: Int(_didAllow ? 1 : 0), textValue: String(_didAllow))
	}
	
	public func setValue(_ value: QuestionResponse?) {
		
	}

}
