//
//  GridTestTutorialViewController.swift
//  Arc
//
//  Created by Philip Hayes on 7/19/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import UIKit
import ArcUIKit
class GridTestTutorialViewController: ACTutorialViewController, GridTestViewControllerDelegate {
	
	enum TestPhase {
		case start, fs, fsTimed, recallFirstStep, recallFirstChoiceMade, recallSecondChoiceMade, showingReminder, recall, end
		
		
	}
	
	let test:GridTestViewController = .get()
	
	var selectionMade = false
	var isMakingSelections = false
	var lockIncorrect = false
	var maxGridSelected = 3
	var gridSelected = 0
	var phase:TestPhase = .start
    override func viewDidLoad() {
		duration = 20
        super.viewDidLoad()
        test.isPracticeTest = true
		test.shouldAutoProceed = false
		test.delegate = self
		setupScript()
		addChild(test)
		customView.setContent(viewController: test)
		test.tapOnTheFsLabel.isHidden = true
		test.IMAGE_HEIGHT = 95
        // Do any additional setup after loading the view.
        if self.get(flag: .grids_tutorial_shown) == false {
            self.customView.firstTutorialRun()
        }
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		view.window?.clearOverlay()
		view.removeHighlight()
		currentHint?.removeFromSuperview()
		
	}
    override func finishTutorial() {
        self.set(flag: .grids_tutorial_shown)
        super.finishTutorial()
    }
	func didSelect(){
		
		
		currentHint?.removeFromSuperview()
		switch phase {
		
		
		case .start:
			view.window?.clearOverlay()
			view.removeHighlight()
			tutorialAnimation.resume()

			break
		case .recallFirstStep:
			view.window?.clearOverlay()
			view.removeHighlight()
			removeHint(hint: "hint")
			tutorialAnimation.time = 10
			addFirstHint(hint: "hint")
			tutorialAnimation.resume()

		case .recallFirstChoiceMade, .recallSecondChoiceMade:
			view.window?.clearOverlay()
			view.removeHighlight()
			removeHint(hint: "hint")
			tutorialAnimation.time = 10
			needHelp()
			tutorialAnimation.resume()


		case .recall:
			view.window?.clearOverlay()
			view.removeHighlight()
			removeHint(hint: "hint")

			needHelp()

			tutorialAnimation.resume()
			
		case .fs:
			view.window?.clearOverlay()
			view.removeHighlight()
			tutorialAnimation.resume()

			test.collectionView.isUserInteractionEnabled = false
		
		case .fsTimed:
			view.window?.clearOverlay()
			view.removeHighlight()
			test.collectionView.isUserInteractionEnabled = true

		
		
		case .end:
			view.window?.clearOverlay()
			view.removeHighlight()
			removeHint(hint: "hint")

			tutorialAnimation.time = 19
			tutorialAnimation.resume()
			break
		case .showingReminder:
			removeHint(hint: "hint")

		}
		
		selectionMade = true
	}
	
	func didSelectGrid(indexPath: IndexPath) {
		gridSelected += 1
		
		switch gridSelected  {
		case 1:
			phase = .recallFirstChoiceMade
		case 2:
			phase = .recallSecondChoiceMade
		case 3:
			test.collectionView.isUserInteractionEnabled = false
			phase = .end
		default:
			phase = .recallFirstStep
		}
		
		didSelect()
	}
	
	func didSelectLetter(indexPath: IndexPath) {
			didSelect()
	}
	
	func didDeselectGrid(indexPath: IndexPath) {
		
		gridSelected -= 1
		
		
		switch gridSelected  {
		case 0:
			phase = .recallFirstStep
		case 1:
			phase = .recallFirstChoiceMade
		case 2:
			phase = .recallSecondChoiceMade
		case 3:
			test.collectionView.isUserInteractionEnabled = false
			removeHint(hint: "hint")
			phase = .end
		default:
			phase = .recallFirstStep
		}
		
		
		didSelect()
	}
	
	func didDeselectLeter(indexPath: IndexPath) {
		didSelect()
	}

	func setupScript() {
		state.addCondition(atTime: progress(seconds: 0), flagName: "start-0") { [weak self] in
			guard let weakSelf = self else {
				return
			}
			weakSelf.buildStartScreen(message: "In this three part test, you’ll be asked to *recall the location* of these items.",
									  buttonTitle: "Got it")
			
		}
		state.addCondition(atTime: progress(seconds: 0), flagName: "start-1") { [weak self] in
			guard let weakSelf = self else {
				return
			}
			weakSelf.progress = 0.1
			weakSelf.tutorialAnimation.pause()
			weakSelf.test.displaySymbols()
			weakSelf.view.window?.overlayView(withShapes: [])
			weakSelf.currentHint = weakSelf.view.window?.hint {
				$0.content = "The items will be placed in a grid of boxes. *Remember which box each item is in.* You will have 3 seconds."
				$0.buttonTitle = "I'm Ready"
				let p = weakSelf.progress
				$0.onTap = { [weak self] in
					
					weakSelf.phase = .start
					Animate().duration(2.9).run {
						t in
						weakSelf.customView.progressBar.config.progress = CGFloat(Math.lerp(a: Double(p), b: 0.29, t: Double(t)))
						weakSelf.customView.progressBar.setNeedsDisplay()
						return true
					}
					self?.didSelect()
				}
				
				$0.layout {
					$0.centerY == weakSelf.view.centerYAnchor
					$0.centerX == weakSelf.view.centerXAnchor

					$0.width == weakSelf.test.collectionView.widthAnchor - 20
					
				}
			}
			
		}
		state.addCondition(atTime: progress(seconds: 3), flagName: "start-2") { [weak self] in
			guard let weakSelf = self else {
				return
			}
			weakSelf.progress = 0.3
			weakSelf.tutorialAnimation.pause()
			weakSelf.test.displaySymbols()
			weakSelf.view.window?.overlayView(withShapes: [])
			weakSelf.currentHint = weakSelf.view.window?.hint {
				$0.content = "*Great!*\nLet's proceed to part two."
				$0.buttonTitle = "Next"
				$0.onTap = { [weak self] in
					self?.didSelect()
				}
				
				$0.layout {
					$0.centerY == weakSelf.view.centerYAnchor
					$0.centerX == weakSelf.view.centerXAnchor
					
					$0.width == weakSelf.test.collectionView.widthAnchor - 20
					
				}
			}
			
		}
		
		state.addCondition(atTime: progress(seconds: 3), flagName: "fs-0") { [weak self] in
			guard let weakSelf = self else {
				return
			}
			weakSelf.test.displayFs()
			weakSelf.test.collectionView.isUserInteractionEnabled = true

			
			
		}
		state.addCondition(atTime: progress(seconds: 3.5), flagName: "fs-2") { [weak self] in
			guard let weakSelf = self else {
				return
			}
			weakSelf.progress = 0.4
			weakSelf.tutorialAnimation.pause()
			weakSelf.phase = .fs
			let index = weakSelf.test.fIndexPaths[3]
			guard let cell = weakSelf.test.overlayCell(at: index) else {
				return
			}
            cell.highlight(radius: cell.frame.width/2)
            cell.overlay(radius: cell.frame.width/2)

			weakSelf.test.collectionView.isUserInteractionEnabled = true

			weakSelf.currentHint = weakSelf.view.window?.hint {
				$0.content = "Tap this letter F."
				
				
				$0.layout {
					$0.top >= weakSelf.view.safeAreaLayoutGuide.topAnchor + 24
					$0.leading >= weakSelf.view.safeAreaLayoutGuide.leadingAnchor + 24
					$0.trailing <= weakSelf.view.safeAreaLayoutGuide.trailingAnchor - 24
					$0.bottom <= weakSelf.view.safeAreaLayoutGuide.bottomAnchor - 24
					
//					$0.width == weakSelf.test.collectionView.widthAnchor - 20
					$0.height == 60
					
					$0.centerY == cell.centerYAnchor + 80 ~ 500
					$0.centerX == cell.centerXAnchor ~ 500
					
					
					
				}
			}
			
		}
		state.addCondition(atTime: progress(seconds: 3.5), flagName: "fs-3") { [weak self] in
			guard let weakSelf = self else {
				return
			}
			weakSelf.progress = 0.5
			weakSelf.tutorialAnimation.pause()
			weakSelf.view.window?.overlayView(withShapes: [])
			weakSelf.currentHint = weakSelf.view.window?.hint {
				$0.content = "*Perfect!*\nNow: *Tap all the F’s* you see as quickly as you can.\nYou will have 3 seconds."
				$0.buttonTitle = "I'm Ready"
				$0.onTap = { [weak self] in
					self?.didSelect()
					weakSelf.phase = .fsTimed
					weakSelf.isMakingSelections = false
					weakSelf.test.collectionView.isUserInteractionEnabled = true

					let p = weakSelf.progress
					Animate().duration(2.9).run {
						t in
						weakSelf.customView.progressBar.config.progress = CGFloat(Math.lerp(a: Double(p), b: 0.7, t: Double(t)))
						weakSelf.customView.progressBar.setNeedsDisplay()
						return true
					}
				}
				
				$0.layout {
					$0.centerY == weakSelf.view.centerYAnchor
					$0.centerX == weakSelf.view.centerXAnchor
					
					$0.width == weakSelf.test.collectionView.widthAnchor
					
				}
			}
			
		}
		
		state.addCondition(atTime: progress(seconds: 6.5), flagName: "fs-4") { [weak self] in
			guard let weakSelf = self else {
				return
			}
			weakSelf.progress = 0.8

			weakSelf.tutorialAnimation.pause()
			weakSelf.view.window?.overlayView(withShapes: [])
			weakSelf.test.collectionView.isUserInteractionEnabled = false
			weakSelf.phase = .fs
			weakSelf.currentHint = weakSelf.view.window?.hint {
				$0.content = "*Nice work!*\nDon't worry if you didn't find them all."
				$0.buttonTitle = "Next"
				$0.onTap = {
					weakSelf.phase = .recallFirstStep
					weakSelf.didSelect()
					weakSelf.test.clearGrids()
					weakSelf.buildStartScreen(message: "In the final part of the test, you will select the three boxes where these items were located in part one.",
											  buttonTitle: "I'm Ready")
				}
				
				$0.layout {
					$0.centerY == weakSelf.view.centerYAnchor
					$0.centerX == weakSelf.view.centerXAnchor
					
					$0.width == weakSelf.test.collectionView.widthAnchor
					
				}
			}
			
		}
		
		state.addCondition(atTime: progress(seconds: 6.5), flagName: "symbols-0") { [weak self] in
			guard let weakSelf = self else {
				return
			}
			weakSelf.test.displayGrid()
			weakSelf.test.collectionView.isUserInteractionEnabled = true
			weakSelf.needHelp()
			weakSelf.isMakingSelections = true

			
		}
		state.addCondition(atTime: progress(seconds: 20), flagName: "end") { [weak self] in
			guard let weakSelf = self else {
				return
			}
			weakSelf.finishTutorial()
		}
	}
	func buildStartScreen(message:String, buttonTitle:String) {
		tutorialAnimation.pause()
		let view = customView.containerView.view {
			$0.backgroundColor = .white
			$0.layout {
				$0.top == customView.containerView.topAnchor ~ 998
				$0.leading == customView.containerView.leadingAnchor ~ 998
				$0.trailing == customView.containerView.trailingAnchor ~ 998
				$0.bottom == customView.containerView.bottomAnchor ~ 998
			}
		}
		var image:UIImageView!
		let _ = view.stack {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.distribution = .fillEqually
			$0.axis = .horizontal
			$0.spacing = 20
			
			
			$0.image {
				$0.image = #imageLiteral(resourceName: "phone")
			}
			image = $0.image {
				$0.image = #imageLiteral(resourceName: "key")
			}
			$0.image {
				$0.image = #imageLiteral(resourceName: "pen")
			}
			$0.layout {
				
				$0.centerX == view.centerXAnchor
				
				$0.height == 100
				$0.centerY == view.centerYAnchor - 100
				
			}
		}
		currentHint = view.window?.hint {
			$0.content = message
			$0.buttonTitle = "Got it"
			$0.onTap = { [weak self] in
				view.removeFromSuperview()
				self?.didSelect()
			}
			$0.layout {
				$0.centerY == image.bottomAnchor + 100
				$0.centerX == image.centerXAnchor
				$0.width == view.widthAnchor - 48
			
			}
		}
	}
	func removeHint(hint:String) {
		_ = state.removeCondition(with: hint)
	}
	func needHelp() {
		
		let time = tutorialAnimation.time + 3
		print("HINT:", time, ":",  progress(seconds:time))
		state.addCondition(atTime: progress(seconds:time), flagName: "hint") {
			[weak self] in
			guard let weakSelf = self else {
				return
			}
			weakSelf.tutorialAnimation.pause()
			
			
			//Otherwise let's give them a choice.
			weakSelf.currentHint = weakSelf.view.window?.hint {
				$0.content  = "".localized("popup_tutorial_needhelp")
				$0.buttonTitle = "".localized(ACTranslationKey.popup_tutorial_remindme)
				$0.onTap = {[weak self] in
					weakSelf.currentHint?.removeFromSuperview()
					//Remove the hint so that it will fire again
					self?.removeHint(hint: "hint")
					//If they selected one we'll show the double hint.
					if self?.gridSelected == 1 {
						self?.addDoubleHint(hint: "hint", seconds: 0.0)
						self?.tutorialAnimation.resume()
						self?.phase = .showingReminder
					//If they selected two, then we show the single hint
					} else if self?.gridSelected == 2 {
						self?.addFinalHint(hint: "hint", seconds: 0.0)
						self?.tutorialAnimation.resume()
						self?.phase = .showingReminder

					} else {
						//Otherwise show the first,
						//the user has removed a selection before this hint appeared
						self?.addFirstHint(hint: "hint", seconds: 0.0)
						self?.tutorialAnimation.resume()
					}
					
				}
				
				$0.layout {
					$0.centerX == weakSelf.view.centerXAnchor
					$0.centerY == weakSelf.view.centerYAnchor
					
				}
			}
			
		}
	}
	func continueTutorial() {
		
			test.collectionView.overlay()
			currentHint = view.window?.hint {
				$0.content  = "".localized(ACTranslationKey.popup_tutorial_tapbox)
				
				
				$0.layout {
					$0.bottom == test.collectionView.topAnchor - 20
					$0.centerX == view.centerXAnchor
					
				}
			}

	}
	func addDoubleHint(hint:String, seconds:TimeInterval = 3.0) {
		let time = tutorialAnimation.time + seconds
		print("HINT:", time, ":",  progress(seconds:time))
		state.addCondition(atTime: progress(seconds:time), flagName: hint) {
			[weak self] in
			guard let weakSelf = self else {
				return
			}
			weakSelf.tutorialAnimation.pause()
			let selected = weakSelf.test.collectionView.indexPathsForSelectedItems ?? []
			let index = weakSelf.test.symbolIndexPaths.filter {
				return !selected.contains($0)
			}
			weakSelf.test.overlayCells(at: index)
			
			weakSelf.currentHint = weakSelf.view.window?.hint {
				$0.content  = "".localized("popup_tutorial_tapbox2")
				
				$0.layout {
					$0.centerX == weakSelf.view.centerXAnchor
					$0.width == 252
					$0.bottom == weakSelf.test.collectionView.topAnchor - 20
				
					
				}
			}
			
		}
		
		
	}
	func addFinalHint(hint:String, seconds:TimeInterval = 3.0) {
		let time = tutorialAnimation.time + seconds
		print("HINT:", time, ":",  progress(seconds:time))
		state.addCondition(atTime: progress(seconds:time), flagName: hint) {
			[weak self] in
			guard let weakSelf = self else {
				return
			}
			weakSelf.tutorialAnimation.pause()
			let index = weakSelf.test.symbolIndexPaths[min(2, weakSelf.gridSelected)]
			guard let cell = weakSelf.test.overlayCell(at: index) else {
				return
			}
			weakSelf.currentHint = weakSelf.view.window?.hint {
				$0.content = """
				*Hint:* One item was located
				in this box. Tap here.
				""".localized(ACTranslationKey.popup_tutorial_tapbox3)
				
				
				$0.layout {
					$0.centerX == weakSelf.view.centerXAnchor
					$0.width == 252
					
					if index.row/5 > 2 {
						//If above
						$0.bottom == cell.topAnchor + 40

					} else {
						
						$0.top == cell.bottomAnchor + 40

					}
					
				}
			}
			
		}
		
		
	}
	func addFirstHint(hint:String, seconds:TimeInterval = 3.0) {
		let time = tutorialAnimation.time + seconds
		print("HINT:", time, ":",  progress(seconds:time))
		state.addCondition(atTime: progress(seconds:time), flagName: hint) {
			[weak self] in
			guard let weakSelf = self else {
				return
			}
			weakSelf.tutorialAnimation.pause()
			let index = weakSelf.test.symbolIndexPaths[min(2, weakSelf.gridSelected)]
			guard let cell = weakSelf.test.overlayCell(at: index) else {
				return
			}
			weakSelf.currentHint = weakSelf.view.window?.hint {
				$0.content = """
				*Hint:* One item was located
				in this box. Tap here.
				""".localized(ACTranslationKey.popup_tutorial_boxhint)
				
				
				$0.layout {
					$0.centerX == weakSelf.view.centerXAnchor
					$0.width == 252
					
					if index.row/5 > 2 {
						//If above
						$0.bottom == cell.topAnchor + 40
						
					} else {
						
						$0.top == cell.bottomAnchor + 40
						
					}
					
				}
			}
			
		}
		
		
	}
}