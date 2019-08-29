//
//  EarningsViewController.swift
//  Arc
//
//  Created by Philip Hayes on 8/14/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import UIKit
import ArcUIKit
public class EarningsViewController: CustomViewController<ACEarningsView> {
	var thisStudy:ThisStudyExpressible = Arc.shared.studyController
	var thisWeek:ThisWeekExpressible = Arc.shared.studyController

	var lastUpdated:TimeInterval?
	var earningsData:EarningOverview?
	var dateFormatter = DateFormatter()
	var isPostTest:Bool = false
	
	public init(isPostTest:Bool) {
		super.init(nibName: nil, bundle: nil)
		self.isPostTest = isPostTest
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override public func viewDidLoad() {
		
        super.viewDidLoad()
		
		
		//When in post test mode perform modifications 
		if isPostTest {
			customView.backgroundView.image = UIImage(named: "finished_bg", in: Bundle(for: self.classForCoder), compatibleWith: nil)
			customView.button.isHidden = true
			customView.nextButton?.isHidden = false
			customView.earningsSection.backgroundColor = .clear
			customView.button.isHidden = true
			customView.headerLabel.textAlignment = .center
			customView.headerLabel.text = "".localized(ACTranslationKey.progress_earnings_header)
			
			customView.viewDetailsButton.isHidden = true
			customView.separator.isHidden = true
			customView.earningsBodyLabel.isHidden = true
			customView.lastSyncedLabel.isHidden = true
			
			customView.bonusGoalsSection.backgroundColor = .clear
			customView.bonusGoalsHeader.textAlignment = .center
			customView.bonusGoalsSeparator.isHidden = true
			
			customView.bonusGoalsBodyLabel.textAlignment = .center
			Roboto.Style.body(customView.bonusGoalsBodyLabel, color:.white)
			
			
			
		} else {
			customView.root.refreshControl = UIRefreshControl()
			customView.root.addSubview(customView.root.refreshControl!)
			customView.root.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
			
			customView.root.alwaysBounceVertical = true
		}
		dateFormatter.locale = app.appController.locale.getLocale()
		dateFormatter.dateFormat = "MMM dd 'at' hh:mm a"
		NotificationCenter.default.addObserver(self, selector: #selector(updateEarnings(notification:)), name: .ACEarningsUpdated, object: nil)
		
		customView.viewDetailsButton.addAction {
			[weak self] in
			guard let weakSelf = self else {
				return
			}
			self?.navigationController?.pushViewController(EarningsDetailViewController(), animated: true)
		}
        // Do any additional setup after loading the view.
		
		
    }
	@objc func refresh(sender:AnyObject)
	{
		
		//my refresh code here..
		print("refreshing")
		NotificationCenter.default.post(name: .ACStartEarningsRefresh, object: nil)
	}
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		lastUpdated = app.appController.lastFetched["EarningsOverview"]
		earningsData = Arc.shared.appController.read(key: "EarningsOverview")
		setGoals()
	}
	@objc public func updateEarnings(notification:Notification) {
		
		OperationQueue.main.addOperation { [weak self] in

			guard let weakSelf = self else {
				return
			}
			weakSelf.customView.root.refreshControl?.endRefreshing()

			weakSelf.lastUpdated = weakSelf.app.appController.lastFetched["EarningsOverview"]
			weakSelf.earningsData = Arc.shared.appController.read(key: "EarningsOverview")
			weakSelf.setGoals()
			
		}
		
	}
	
	fileprivate func updateBodyText() {
		if let last = lastUpdated {
			let date = Date(timeIntervalSince1970: last)
			if date.addingMinutes(minutes: 1).minutes(from: Date()) < 1 {
				customView.lastSyncedLabel.text = "\("".localized(ACTranslationKey.earnings_sync)) \(dateFormatter.string(from: date))"
			}
		}
		customView.bonusGoalsBodyLabel.text = "".localized(ACTranslationKey.earnings_bonus_body)
		
		switch thisStudy.studyState {
		case .baseline:
			customView.earningsBodyLabel.text = "".localized(ACTranslationKey.earnings_body0)
			
			break
		default:
			customView.earningsBodyLabel.text = "".localized(ACTranslationKey.earnings_body1)
			
			
			break
		}
	}
	
	fileprivate func fourofFourGoal(_ fourOfFourGoal:EarningOverview.Response.Earnings.Goal) {
		let components = fourOfFourGoal.progress_components
		
		for component in components.enumerated() {
			let index = component.offset
			let value = component.element
			customView.fourofFourGoal.set(progress:Double(value)/100.0, for: index)
		}
		
		customView.fourofFourGoal.set(isUnlocked: fourOfFourGoal.completed)
		customView.fourofFourGoal.set(bodyText: "".localized(ACTranslationKey.earnings_4of4_body)
			.replacingOccurrences(of: "{AMOUNT}", with: fourOfFourGoal.value))
		customView.fourofFourGoal.goalRewardView.set(text: fourOfFourGoal.value)
	}
	
	fileprivate func twoADayGoal(_ twoADay:EarningOverview.Response.Earnings.Goal) {
		let components = twoADay.progress_components
		for component in components.enumerated() {
			let index = component.offset
			let value = component.element
			customView.twoADayGoal.set(progress:Double(min(2, value))/2.0, forIndex: index)
		}
		customView.twoADayGoal.set(isUnlocked: twoADay.completed)
		customView.twoADayGoal.set(bodyText: "".localized(ACTranslationKey.earnings_2aday_body)
			.replacingOccurrences(of: "{AMOUNT}", with: twoADay.value))
		customView.twoADayGoal.goalRewardView.set(text: twoADay.value)
	}
	
	fileprivate func totalSessionsGoal(_ totalSessions:EarningOverview.Response.Earnings.Goal) {
		for component in totalSessions.progress_components.enumerated() {
			let value = component.element
			customView.totalSessionsGoal.set(total: 21.0)
			customView.totalSessionsGoal.set(current: value)
			
		}
		customView.totalSessionsGoal.set(isUnlocked: totalSessions.completed)
		customView.totalSessionsGoal.set(bodyText: "".localized(ACTranslationKey.earnings_21tests_body)
			.replacingOccurrences(of: "{AMOUNT}", with: totalSessions.value))
		customView.totalSessionsGoal.goalRewardView.set(text: totalSessions.value)
	}
	
	public func setGoals() {
		
		
		updateBodyText()
		
		customView.twoADayGoal.add(tiles: thisWeek.daysArray.suffix(7))
		guard let earnings = earningsData?.response?.earnings else {
			return
		}
		if isPostTest {
			for a in earnings.new_achievements {
				customView.add(reward: (a.name, a.amount_earned))
			}
		}
		
		customView.thisWeeksEarningsLabel.text = earnings.total_earnings
		customView.thisStudysEarningsLabel.text = earnings.cycle_earnings
		
		for goal in earnings.goals {
			switch goal.name {
			case "4-out-of-4":
				fourofFourGoal(goal)
			case "2-a-day":
				twoADayGoal(goal)
			case "21-sessions":
				totalSessionsGoal(goal)
			default:
				break
			}
		}
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