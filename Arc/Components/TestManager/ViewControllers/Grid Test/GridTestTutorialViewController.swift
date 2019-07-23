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
	
	let test:GridTestViewController = .get()
	
	var selectionMade = false
	var isMakingSelections = false
	var maxGridSelected = 3
	var gridSelected = 0
    override func viewDidLoad() {
        super.viewDidLoad()
		test.shouldAutoProceed = false
		test.delegate = self
		setupScript()
		addChild(test)
		customView.setContent(viewController: test)
		test.tapOnTheFsLabel.isHidden = true
        // Do any additional setup after loading the view.
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
	func didSelect(_ enableInteraction:Bool = false){
		view.window?.clearOverlay()
		view.removeHighlight()
		currentHint?.removeFromSuperview()
		if !isMakingSelections {

			tutorialAnimation.resume()
		}
		selectionMade = true
		test.collectionView.isUserInteractionEnabled = enableInteraction

	}
	
	func didSelectGrid(indexPath: IndexPath) {
		gridSelected += 1
		if isMakingSelections && gridSelected == maxGridSelected {
			isMakingSelections = false
		}
		didSelect(isMakingSelections)
	}
	
	func didSelectLetter(indexPath: IndexPath) {
			didSelect(isMakingSelections)
	}
	
	func didDeselectGrid(indexPath: IndexPath) {
		
		gridSelected -= 1
		
		didSelect(isMakingSelections)
	}
	
	func didDeselectLeter(indexPath: IndexPath) {
		didSelect(isMakingSelections)
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

					$0.width == weakSelf.test.collectionView.widthAnchor
					
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
					
					$0.width == weakSelf.test.collectionView.widthAnchor
					
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

			let index = weakSelf.test.fIndexPaths[weakSelf.test.fIndexPaths.count/2]
			guard let cell = weakSelf.test.overlayCell(at: index) else {
				return
			}
			weakSelf.test.collectionView.isUserInteractionEnabled = true

			weakSelf.currentHint = weakSelf.view.window?.hint {
				$0.content = "Tap this letter F."
				
				
				$0.layout {
					$0.top >= weakSelf.view.safeAreaLayoutGuide.topAnchor + 24
					$0.leading >= weakSelf.view.safeAreaLayoutGuide.leadingAnchor + 24
					$0.trailing <= weakSelf.view.safeAreaLayoutGuide.trailingAnchor - 24
					$0.bottom <= weakSelf.view.safeAreaLayoutGuide.bottomAnchor - 24
					
					$0.width == weakSelf.test.collectionView.widthAnchor
					$0.height == 80
					
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
			weakSelf.currentHint = weakSelf.view.window?.hint {
				$0.content = "*Nice work!*\nDon't worry if you didn't find them all."
				$0.buttonTitle = "Next"
				$0.onTap = {
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
			weakSelf.tutorialAnimation.pause()
			weakSelf.isMakingSelections = true

			
		}
		state.addCondition(atTime: progress(seconds: 10), flagName: "end") { [weak self] in
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
		let stack = view.stack {
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

}