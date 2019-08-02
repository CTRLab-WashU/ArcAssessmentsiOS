//
//  EndOfFirstTestProgressViewController.swift
//  Arc
//
//  Created by Philip Hayes on 8/1/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import UIKit

public class ACTodayProgressViewController: CustomViewController<ACTodayProgressView> {
	public struct Config{
		public struct SessionData {
			var started:Bool = false
			var progress:Int = 0
			var total:Int = 3
		}
		
		
		
		var sessionsCompleted:Int {
			var complete:Int = 0
			for session in sessionData {
				if session.progress == session.total {
					complete += 1
				}
			}
			return complete
		}
		
		
		var sessionsStarted:Int {
			var started:Int = 0
			for session in sessionData {
				if session.started == true {
					started += 1
				}
			}
			return started
		}
		
		var totalSessions:Int = 4
		var sessionData:[SessionData]
		
		
	}
	public init(with config:Config = testConfig) {
		super.init(nibName: nil, bundle: nil)
		
		let isComplete = config.sessionsStarted == config.totalSessions
		if isComplete {
			customView.set(completed: true)
			customView.set(sessionsCompleted: config.sessionsCompleted)
			customView.set(sessionsRemaining: nil)
		} else {
			customView.set(completed: false)
			customView.set(sessionsCompleted: config.sessionsCompleted)
			customView.set(sessionsRemaining: config.totalSessions - config.sessionsStarted)
		}
		for index in 0 ..< config.sessionData.count {
			let session = config.sessionData[index]
			
			customView.set(progress: Double(session.progress)/Double(session.total),
						   for: index)
		}
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
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
public var testConfig = ACTodayProgressViewController.Config(totalSessions: 4,
																		 sessionData: [
																			ACTodayProgressViewController.Config.SessionData(started: true, progress: 3, total: 3),
																			ACTodayProgressViewController.Config.SessionData(started: true, progress: 3, total: 3),
																			ACTodayProgressViewController.Config.SessionData(started: true, progress: 3, total: 3),
																			ACTodayProgressViewController.Config.SessionData(started: true, progress: 3, total: 3)
	])
