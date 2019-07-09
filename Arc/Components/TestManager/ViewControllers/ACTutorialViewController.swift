//
//  ACTutorialViewController.swift
//  Arc
//
//  Created by Philip Hayes on 7/3/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import UIKit
import ArcUIKit

struct TutorialState {
	struct TutorialCondition {
		var time:Double
		var flag:String
		var onFlag:(()->Void)
		
	}
	var conditions = [TutorialCondition]()
	var flags = Set<String>()
	var maxSteps = 0
	var progress:Double {
		if conditions.count > 0 {
			return 1.0 - Double(conditions.count) / Double(maxSteps)
		}
		return 0.0
	}
	
	
	/// Adds a condition based on time to perform an action
	/// - Parameter time: a time in the range of 0.0 to 1.0
	/// - Parameter flag: the name of the flag to identify it by
	/// - Parameter onFlag: an action to perform when flagged
	mutating func addCondition(atTime time:Double, flagName flag:String, onFlag:@escaping (()->Void)) {
		maxSteps += 1
		conditions.append(TutorialCondition(time: time, flag: flag, onFlag: onFlag))
		conditions.sort {$0.time < $1.time}
	}
	mutating func setFlag(value:String) {
		 flags.insert(value)
	}
	mutating func evaluate(_ time:Double) -> String? {
		var removeIndex:Int?
		for index in 0 ..< conditions.count {
			let c = conditions[index]
			
			if time >= c.time && !flags.contains(c.flag) {
				flags.insert(c.flag)
				c.onFlag()
				
				removeIndex = index
				break
			} else {
				break
			}
		}
		if let index = removeIndex {
			//Return the removed flag
			return conditions.remove(at: index).flag
		}
		return nil
	}
}


class ACTutorialViewController: CustomViewController<TutorialView> {
	var tutorialAnimation:Animate = Animate()
	.duration(10)
	
	var state:TutorialState = TutorialState()
	override func viewDidLoad() {
        super.viewDidLoad()

		
    }
	func startTutorialAnimation() {
		state = TutorialState()
		tutorialAnimation.run {[weak self]
			progress in
			_ = self?.state.evaluate(progress)
		}
	}
	func stopTutorialanimation() {
		tutorialAnimation.stop()
	}
	func pauseTutorialAnimation() {
		tutorialAnimation.pause()
	}
	func resumeTutorialanimation() {
		tutorialAnimation.resume()
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		startTutorialAnimation()
	}
	func handleStep(time:Double) {
		
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