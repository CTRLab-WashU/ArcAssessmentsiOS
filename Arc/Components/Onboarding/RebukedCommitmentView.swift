//
//  RebukedCommitmentView.swift
//  Arc
//
//  Created by Philip Hayes on 8/29/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import Foundation
import ArcUIKit
import HMMarkup
public class RebukedCommitmentView : ACTemplateView {
	weak var contactStudyCoordinatorButton:ACButton!
	public override func content(_ view: UIView) {
		backgroundColor = ACColor.primary
		backgroundView.image = UIImage(named: "availability_bg", in: Bundle(for: self.classForCoder), compatibleWith: nil)
		view.acLabel {
			Roboto.Style.headingMedium($0, color: .white)
			$0.text = "".localized(ACTranslationKey.onboarding_nocommit_landing_header)
			$0.textAlignment = .center
		}
		view.acLabel {
			Roboto.Style.body($0, color: .white)
			$0.text = "".localized(ACTranslationKey.onboarding_nocommit_landing_body)
			$0.textAlignment = .center
			
		}
	}
	public override func footer(_ view: UIView) {
		contactStudyCoordinatorButton = view.acButton {
			$0.primaryColor = .clear
			$0.secondaryColor = .clear
			$0.setTitleColor(.white, for: .normal)
			

			$0.tintColor = .black
			$0.titleLabel?.textColor = .black
			$0.setTitle("".localized(ACTranslationKey.resources_contact), for: .normal)
			$0.addAction {
				Arc.shared.appNavigation.navigate(vc:Arc.shared.appNavigation.defaultHelpState() , direction: .toRight)
			}
		
			Roboto.PostProcess.link($0.titleLabel!)
			
		}
		
		nextButton = view.acButton {
			$0.primaryColor = ACColor.secondary
			$0.secondaryColor = ACColor.secondaryGradient
			$0.setTitleColor(ACColor.badgeText, for: .normal)
			$0.setTitle("".localized(ACTranslationKey.button_next), for: .normal)
			
		}
	}
	
}


