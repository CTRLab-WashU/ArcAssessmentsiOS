//
//  NotificationsRejected.swift
//  Arc
//
//  Created by Philip Hayes on 2/20/20.
//  Copyright © 2020 HealthyMedium. All rights reserved.
//

import Foundation

import UIKit

public class NotificationsRejectedViewController : CustomViewController<InfoView>, SurveyInput {
	public var useDarkStatusBar:Bool = false
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return useDarkStatusBar ? .default : .lightContent
    }
	
	public var orientation: UIStackView.Alignment = .top

	
	public var surveyInputDelegate: SurveyInputDelegate?
	
	
	
	public func getValue() -> QuestionResponse? {
		return nil
	}
	
	public func setValue(_ value: QuestionResponse?) {
		
	}
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		
	}
	public func updateState() {
		customView.nextButton?.setTitle("".localized(ACTranslationKey.button_settings), for: .normal)
		Arc.shared.notificationController.authenticateNotifications { [weak self] (granted, error) in
			OperationQueue.main.addOperation {
				Arc.shared.appController.isNotificationAuthorized = granted
				if !granted {
					self?.customView.nextButton?.setTitle("".localized(ACTranslationKey.button_settings), for: .normal)

				} else {
					self?.customView.nextButton?.setTitle("".localized(ACTranslationKey.button_next), for: .normal)
					self?.surveyInputDelegate?.didChangeValue()
					self?.surveyInputDelegate?.tryNextPressed()
				}
				
				
				
			}
			
		}
	}
	public override func viewDidLoad() {
		super.viewDidLoad()
		
        useDarkStatusBar = false
        setNeedsStatusBarAppearanceUpdate()
		customView.addSpacer()

        customView.backgroundView.image = Arc.shared.image(named: "availability_bg", in: Bundle.module, compatibleWith: nil)
		customView.infoContent.alignment = .center
		customView.backgroundColor = UIColor(named:"Primary")!
		customView.setTextColor(UIColor(named: "Secondary Text"))
        
        // Record that we've shown the notifications rejected screen, fix related to DIAN-76
        UserDefaults.standard.setValue(true, forKey: "rejectedFirstNotifications")
		
		customView.setButtonColor(style:.secondary)
		
		customView.nextButton?.setTitle("".localized(ACTranslationKey.button_settings), for: .normal)
		customView.nextButton?.addAction {  [weak self] in
			Arc.shared.notificationController.authenticateNotifications { [weak self] (granted, error) in
				OperationQueue.main.addOperation {
					Arc.shared.appController.isNotificationAuthorized = granted
					if !granted {
						guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
							return
						}
						
						if UIApplication.shared.canOpenURL(settingsUrl) {
							UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
								print("Settings opened: \(success)") // Prints true
							})
						}
					} else {
						self?.surveyInputDelegate?.didChangeValue()
						self?.surveyInputDelegate?.tryNextPressed()
					}
					
					
					
				}
				
			}
			
			
		}
		customView.setHeading("".localized(ACTranslationKey.onboarding_notifications_header2))
		customView.infoContent.headingLabel?.textAlignment = .center
		
		customView.setContentLabel("".localized(ACTranslationKey.onboarding_notifications_body2_ios)
			.replacingOccurrences(of: "{APP NAME}", with: "EXR"))
		
		customView.getContentLabel().textAlignment = .center
		
		
		
		customView.addSpacer()
		
		let button1 = ACButton()
		
		button1.primaryColor = .clear
		button1.secondaryColor = .clear
		button1.topColor = .clear
		button1.bottomColor = .clear
		button1.setTitle("Proceed Without Notifications".localized(ACTranslationKey.button_proceed_without_notifications), for: .normal)
		button1.titleLabel?.textAlignment = .center

		Roboto.PostProcess.link(button1)
		
		button1.addAction {  [weak self] in
            // We are proceeding without fixing notifications. Make sure we record that we've continued past notifications so that
            // when the app opens in the future we don't bug them about it again (DIAN-76).
            UserDefaults.standard.setValue(true, forKey: "passedNotificationsPrompting")
            
			self?.surveyInputDelegate?.tryNextPressed()
		}
		customView.setAdditionalFooterContent(button1)
		

	}
	
	
}
