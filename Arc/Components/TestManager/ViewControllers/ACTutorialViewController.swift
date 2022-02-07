//
//  ACTutorialViewController.swift
//  Arc
//
// Copyright (c) 2022 Washington University in St. Louis
//
// Washington University in St. Louis hereby grants to you a non-transferable,
// non-exclusive, royalty-free license to use and copy the computer code
// provided here (the "Software").  You agree to include this license and the
// above copyright notice in all copies of the Software.  The Software may not
// be distributed, shared, or transferred to any third party.  This license does
// not grant any rights or licenses to any other patents, copyrights, or other
// forms of intellectual property owned or controlled by
// Washington University in St. Louis.
//
// YOU AGREE THAT THE SOFTWARE PROVIDED HEREUNDER IS EXPERIMENTAL AND IS PROVIDED
// "AS IS", WITHOUT ANY WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, INCLUDING
// WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR
// PURPOSE, OR NON-INFRINGEMENT OF ANY THIRD-PARTY PATENT, COPYRIGHT, OR ANY OTHER
// THIRD-PARTY RIGHT.  IN NO EVENT SHALL THE CREATORS OF THE SOFTWARE OR WASHINGTON
// UNIVERSITY IN ST LOUIS BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL, OR
// CONSEQUENTIAL DAMAGES ARISING OUT OF OR IN ANY WAY CONNECTED WITH THE SOFTWARE,
// THE USE OF THE SOFTWARE, OR THIS AGREEMENT, WHETHER IN BREACH OF CONTRACT, TORT
// OR OTHERWISE, EVEN IF SUCH PARTY IS ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
//

import UIKit


class TutorialState {
	struct TutorialCondition {
		var time:Double
        var delay:Double?
		var flag:String
        var waitForFlags:Set<String>?
		var onFlag:(()->Void)
		
	}
	var conditions = [TutorialCondition]()
	var flags = Set<String>()
    var delayedCondition:TutorialCondition?
	var maxSteps = 0
	var duration:Double = 0
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
    func addCondition(atTime time:Double, flagName flag:String, delay:Double? = nil, waitForFlags:Set<String>? = nil, onFlag:@escaping (()->Void)) {
		maxSteps += 1
		conditions.append(TutorialCondition(time: time, delay: delay, flag: flag, waitForFlags: waitForFlags, onFlag: onFlag))
		conditions.sort {$0.time < $1.time}
	}
    func addCondition(_ condition:TutorialCondition) {
        maxSteps += 1
        conditions.append(condition)
        conditions.sort {$0.time < $1.time}
    }
	func setFlag(value:String) {
		 flags.insert(value)
	}
	func removeCondition(with name:String) {
		conditions = conditions.filter {
			$0.flag != name
		}
		flags.remove(name)
	}
	func evaluate(_ time:Double) {
        if let delayedCondition = delayedCondition {
            if time >= delayedCondition.time + (delayedCondition.delay ?? 0) {
                self.delayedCondition = nil

                flags.insert(delayedCondition.flag)
                print(delayedCondition.time * duration, delayedCondition.flag, "DELAYED =-=-=-=-=-=-=-=-=-=-=-=-=-=-")
                delayedCondition.onFlag()
            }
            return
        }
		for index in 0 ..< conditions.count {
			var c = conditions[index]

			if time >= c.time && !flags.contains(c.flag) {

                if let waitForFlags = c.waitForFlags, !flags.isSuperset(of: waitForFlags) {
                    continue
                }
                flags.insert(c.flag)
                conditions.remove(at: index)
                if let delay = c.delay {
                    //Update time so that delay kicks in after all conditions are met(Time/waitForFlags)
                    print(time * duration ,"Updated from", c.time * duration, delay * duration, c.flag, "Set DELAY=-=-=-=-=-=-=-=-=-=-=-=-=-=-")

                    c.time = time

                    delayedCondition = c

                    return
                }
                print(c.time * duration, c.flag, "=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
                c.onFlag()
				return
			} else {
				break
			}
		}
		
		return
	}
}


public class ACTutorialViewController: CustomViewController<TutorialView>, TutorialCompleteViewDelegate {
	var tutorialAnimation:Animate = Animate()
	var progress:CGFloat = 0 {
		didSet {
			customView.progressBar.relativeWidth = progress
		}
	}
	
	var state:TutorialState = TutorialState()
	var duration:Double = 10.0
	override public func viewDidLoad() {
        super.viewDidLoad()
		tutorialAnimation = tutorialAnimation.duration(duration).curve(.linear)
		state = TutorialState()
		customView.closeButton.addAction { [weak self] in
			self?.dismiss(animated: true) {
				self?.view.window?.clearOverlay()
			}
			
		}
    }
	public func closePressed() {
		dismiss(animated: true) {
			
		}
	}
	public func startTutorialAnimation() {
		state.duration = duration
		tutorialAnimation = tutorialAnimation.run {[weak self]
			progress in
			if self?.presentingViewController == nil {
				return false
			}
			_ = self?.state.evaluate(progress)
			return true
		}
	}
    func findCondition(named:String) -> TutorialState.TutorialCondition? {
        if let condition = state.conditions.first (where:{$0.flag == named}) {
            return condition
        }
        return nil
    }
	public func removeCondition(named:String) -> Bool {
		//Find it first
		if let condition = state.conditions.first (where:{$0.flag == named}) {
			//If found remove and return true
			state.removeCondition(with: condition.flag)
			return true
		}
		return false
	}
    //Remove and enable an existing condition
    @discardableResult public func resetCondition(named:String) -> Bool {
        guard let condition = findCondition(named: named) else {
            return false
        }
        state.removeCondition(with: condition.flag)
        state.addCondition(condition)
        return true
    }
	public func jumpToCondition(named:String) -> Bool {
		if let condition = state.conditions.first (where:{$0.flag == named}) {
			let time = condition.time
			tutorialAnimation.time = time * duration
			return true
		}
		return false
	}
    public func setConditionFlag(named:String) {
        state.flags.insert(named)
    }
    public func removeConditionFlag(named:String) {
        state.flags.remove(named)
    }
	public func progress(seconds:TimeInterval, minutes:TimeInterval = 0) -> Double {
		return (seconds + (minutes * 60)) / duration
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
	override public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		startTutorialAnimation()
	}
	override public func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		stopTutorialanimation()
		currentHint?.removeFromSuperview()
	}
	func handleStep(time:Double) {
		
	}
	func finishTutorial() {
        guard progress != 1.0 else { return }
        progress = 1.0
		
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.currentHint?.removeFromSuperview()
            
            self.customView.contentView?.removeFromParent()
            self.customView.contentView?.view.removeFromSuperview()
            
            self.currentHint?.removeFromSuperview()
            let finishView = TutorialCompleteView()
            finishView.updateProgress(0.0)
            
            self.customView.removeArrangedSubview(self.customView.containerView)
            self.customView.addArrangedSubview(finishView)
            finishView.updateProgress(1.0)
            
            finishView.tutorialDelegate = self
        })
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
