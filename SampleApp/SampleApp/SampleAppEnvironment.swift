//
//  EXEnvironment.swift
//  INV
//
//  Created by Philip Hayes on 1/9/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import Foundation
import Arc

enum SampleAppEnvironment : ArcEnvironment {
    
    case prod
    
    
    var privacyPolicyUrl: String? {
        switch self {
        default:
            return "https://wustl.edu/about/compliance-policies/computers-internet-policies/internet-privacy-policy/"
            
        }
    }
    var shouldDisplayDateReminderNotifications: Bool {
        return true
    }

    /*
     adopt variables to override which controllers are supplied in the environment
     */
    var appNavigation: AppNavigationController {
        switch self {
        default:
            //
            return INVAppNavigationController()
            
        }
    }
    var appController: AppController {
        return INVAppController()
    }
    
    var studyController: StudyController {
        return INVStudyController()
    }
    
    var authController: AuthController {
        if (self == .sage) {
            return INVSageAuthController()
        }
        return AuthController()
    }
    
    var sessionController: SessionController {
        if (self == .sage) {
            return SageSessionController()
        }
        return SessionController()
    }
    
    var scheduleController: ScheduleController {
        if (self == .sage) {
            return SageScheduleController()
        }
        return ScheduleController()
    }
    
    var earningsController: EarningsController {
        if (self == .sage) {
            return SageEarningsController()
        }
        return EarningsController()
    }
    
    func configure() {
        //Use this to set class variables or perform setup before the app runs
        SliderView.hideSelection = true
    }
    var gridTestType:GridTestType {
           return .extended
       }
}
