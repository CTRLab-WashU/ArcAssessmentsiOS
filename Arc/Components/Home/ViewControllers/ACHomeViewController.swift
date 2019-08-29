//
//  ACHomeViewController.swift
//  Arc
//
//  Created by Spencer King on 8/27/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import UIKit
import ArcUIKit
open class ACHomeViewController: CustomViewController<ACHomeView> {
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var debugButton: UIButton!
    @IBOutlet weak var surveyButton: UIButton!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    var session:Int?
    var study:Int?
    
    var thisWeek:ThisWeekExpressible = Arc.shared.studyController
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        //        versionLabel.text = "v\(Arc.shared.versionString)"
        //        configureState()
        
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureState()
        if let id = app.participantId {
            Arc.shared.uploadTestData()
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !get(flag: .first_test_begin) {
            currentHint = customView.highlightTutorialTargets()
            set(flag: .first_test_begin)
            
        }
        
        if get(flag: .baseline_completed) && !get(flag: .baseline_onboarding) {
            if thisWeek.isBaseline {
                showBaselineOboarding()
            }
            else if !thisWeek.isBaseline {
                showPaidOnboarding()
            }
        }
    }
    
    // Shown after the baseline test
    func showBaselineOboarding() {
        view.window?.overlayView(withShapes: [])
        view.isUserInteractionEnabled = false
        currentHint = view.window?.hint {
            $0.layout {
                $0.centerX == view.centerXAnchor
                $0.centerY == view.centerYAnchor
                $0.width == 232
                $0.height == 146
            }
            //$0.content = "".localized(ACTranslationKey.popup_nicejob)
            $0.buttonTitle = "".localized(ACTranslationKey.popup_tour)
            $0.onTap = {[unowned self] in
                self.set(flag: .baseline_onboarding)
                self.currentHint?.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                
                NotificationCenter.default.post(name: .ACHomeStartOnboarding, object: nil)
            }
        }
    }
    
    // Shown after paid tests if the user has not previously completed the onboarding flow
    func showPaidOnboarding() {
        view.window?.overlayView(withShapes: [])
        view.isUserInteractionEnabled = false
        currentHint = view.window?.hint {
            $0.layout {
                $0.centerX == view.centerXAnchor
                $0.centerY == view.centerYAnchor
                $0.width == 232
                $0.height == 146
            }
            $0.content = "".localized(ACTranslationKey.popup_nicejob)
            $0.buttonTitle = "".localized(ACTranslationKey.popup_next)
            $0.onTap = {[unowned self] in
                self.set(flag: .baseline_onboarding)
                self.currentHint?.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                
                NotificationCenter.default.post(name: .ACHomeStartOnboarding, object: nil)
            }
        }
    }
    
    func configureState() {
        
        var upcoming:Session?
        var completedStudy:Bool = false
        if let study = app.currentStudy {
            
            upcoming = app.studyController.get(upcomingSessions: Int(study)).first
            completedStudy = (app.studyController.get(upcomingSessions: Int(study)).count == 0) && (app.studyController.getUpcomingStudyPeriod() == nil)
            self.study = study
            
            
            
            if let session = app.availableTestSession {
                self.session = session
            }
        }
        if upcoming == nil, let nextCycle = app.studyController.getUpcomingStudyPeriod()?.sessions?.firstObject as? Session {
            upcoming = nextCycle
        }
        
        let surveyStatus = Arc.shared.getSurveyStatus()
        customView.setState(surveyStatus: surveyStatus)
        customView.surveyButton.addTarget(self, action: #selector(beginPressed(_:)), for: .primaryActionTriggered)
        customView.debugButton.addTarget(self, action: #selector(debug(_:)), for: .primaryActionTriggered)
        
    }
    @objc func beginPressed(_ sender: Any) {
        currentHint?.removeFromSuperview()
        configureState()
        
        guard let session = session else {
            return
        }
        if let study = study {
            
            app.currentTestSession = session
            app.availableTestSession = nil
            app.appController.lastFlaggedMissedTestCount = 0
            
            app.studyController.mark(started: session, studyId: study)
            app.notificationController.clearNotifications(sessionId: session,
                                                          studyId: study)
            app.notificationController.clearNotifications(withIdentifierPrefix: "MissedTests-\(study)")
            app.appController.lastClosedDate = nil;
            
            app.nextAvailableState()
        } else {
            
        }
    }
    
    @IBAction func debug(_ sender: Any) {
        currentHint?.removeFromSuperview()
        
    }
    
}