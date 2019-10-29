//
//  ProgressViewController.swift
//  Arc
//
//  Created by Philip Hayes on 7/24/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import UIKit
import ArcUIKit
public enum StudyState {
	case baseline, active, activeBaseline, inactive, complete, unknown
}
public protocol ThisWeekExpressible {
	var day:Int {get}
	var totalDays:Int {get}
	var daysArray:[String] {get}
	var startDate:String {get}
	var endDate:String {get}
}

public protocol ThisStudyExpressible {
	var week:Int {get}
	var studyState:StudyState {get}
	var totalWeeks:Int {get}
	var joinedDate:String {get}
	var finishDate:String{get}
	var timeBetweenTestingWeeks:String {get}
	var nextTestCycle:String {get}
}
class ProgressViewController: CustomViewController<ACProgressView> {
	
	var todaysProgress:TodaysProgess?
	var thisWeek:ThisWeekExpressible = Arc.shared.studyController
	var thisStudy:ThisStudyExpressible = Arc.shared.studyController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		todaysProgress = Arc.shared.studyController.todaysProgress()
		
		todaysProgressSetup()
		thisWeekProgressSetup()
		
		thisStudyProgressSetup()
		self.navigationController?.isNavigationBarHidden = true

		customView.viewFaqButton.addTarget(self, action: #selector(self.viewFaqPressed), for: .touchUpInside)
    }
    
    @objc func viewFaqPressed() {
        print("viewFaqPressed")
        let vc:FAQViewController = .get()
        self.navigationController?.pushViewController(vc, animated: true);
        
        //        let topic = self.faqTopics[indexPath.row]; // get topic name from assets
        //        let vc = FAQTopicViewController(faqTopic: topic);
        //        self.navigationController?.pushViewController(vc, animated: true);
    }
    
	func todaysProgressSetup() {
		if let today = todaysProgress {
			
			for session in today.sessionData {
				customView.progressViews.addProgressView(progress: session.getTotalProgress())
			}
			
			customView.todaysSessionCompletionLabel.text = "".localized(ACTranslationKey.progress_dailystatus_complete)
				.replacingOccurrences(of: "{#}", with: "\(today.sessionsCompleted)")
			
			if today.totalSessions - today.sessionsStarted == 0 {
				
				customView.todaysSessionRemainingLabel.text = "".localized(ACTranslationKey.progress_schedule_status2)
				
				Roboto.Style.badge(customView.todaysSessionRemainingLabel)
			
			} else {
			
				customView.todaysSessionRemainingLabel.text = "| *\(today.totalSessions - today.sessionsStarted)* Remaining"
				
				Roboto.Style.body(customView.todaysSessionRemainingLabel)
				
			}
			
			
			
		}
	}

	func thisWeekProgressSetup() {
		switch thisStudy.studyState {
		case .baseline:
			customView.dayOfWeekLabel.text = ""
			customView.noticeLabel.text = "Thanks for completing the practice session today! *Your testing week officially begins tomorrow.*"
			customView.weekProgressView.isHidden = true
		case .activeBaseline:
			
			customView.dayOfWeekLabel.text = "".localized(ACTranslationKey.progess_weeklystatus)
				.replacingOccurrences(of: "{#}", with: "\(thisWeek.day)")
			customView.weekProgressView.isHidden = false
			
			customView.weekProgressView.set(step: thisWeek.day - 1, of: thisWeek.daysArray.suffix(7))
			
		case .active:
			
			customView.dayOfWeekLabel.text = "".localized(ACTranslationKey.progess_weeklystatus)
				.replacingOccurrences(of: "{#}", with: "\(thisWeek.day + 1)")
			customView.weekProgressView.isHidden = false
			
			customView.weekProgressView.set(step: thisWeek.day, of: thisWeek.daysArray)
		default:
			break
		}
		
		customView.startDateLabel.text = thisWeek.startDate
		customView.endDateLabel.text = thisWeek.endDate
	
		
	}
	func thisStudyProgressSetup() {
		switch thisStudy.studyState {
		case .baseline:
			hideSections(value:false)
			customView.nextWeekStack.isHidden = true
			customView.weekOfStudyLabel.isHidden = true
			customView.blockProgressView.isHidden = true
		case .active, .activeBaseline:
			hideSections(value: false)
			customView.nextWeekStack.isHidden = true
			customView.weekOfStudyLabel.text = "".localized(ACTranslationKey.progress_studystatus)
				.replacingOccurrences(of: "{#}", with: "\(thisStudy.week)")
		case .inactive:
			let weeksCompleted = "".localized(ACTranslationKey.progress_weekscompleted)
				.replacingOccurrences(of: "{#}", with: "\(thisStudy.week)")
			let weeksRemaining = "".localized(ACTranslationKey.progress_weeksremaining)
				.replacingOccurrences(of: "{#}", with: "\(thisStudy.totalWeeks - thisStudy.week)")
			
			customView.weekOfStudyLabel.text = "\(weeksCompleted)\n\(weeksRemaining)"
			hideSections(value: true)
			customView.nextWeekStack.isHidden = false
			customView.nextTestingCycle.text = thisStudy.nextTestCycle
		case .complete:
			hideSections(value: true)

		case .unknown:
			hideSections(value: true)
		}
		
		
		
		customView.joinDateLabel.text = thisStudy.joinedDate
		customView.finishDateLabel.text = thisStudy.finishDate
		customView.timeBetweenTestWeeksLabel.text = thisStudy.timeBetweenTestingWeeks
		
		
		customView.blockProgressView.set(count: thisStudy.totalWeeks,
										 progress: thisStudy.week - 1,
										 current: (thisStudy.studyState == .active || thisStudy.studyState == .baseline) ? thisStudy.week - 1 : nil)
		
		
	}
	
	func hideSections(value:Bool) {
		customView.todaySection.isHidden = value
		customView.weekSection.isHidden = value
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

