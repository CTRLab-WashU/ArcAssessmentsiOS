//
//  SimplifiedPricesTestTutorialViewController.swift
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


class SimplifiedPricesTestTutorialViewController: PricesTestTutorialViewController {

    override func viewDidLoad() {
		self.duration = 66.6
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
	func getCorrectButton() -> UIView {
		if pricesQuestions.getCorrectOption() == 0 {
			return pricesQuestions.topButton
		} else {
			return pricesQuestions.bottomButton
		}
	}
    override func didSelectPrice(_ option: Int) {
		removeHint(hint: "Hint")
		selectionMade = true
		let conclusions = ["questions3-0-1", "questions3-1-1", "end"]
			.lazy
			.map{self.jumpToCondition(named: $0)}
		
	
		if option == pricesQuestions.getCorrectOption() {
			
			view.window?.clearOverlay()
			view.removeHighlight()
			currentHint?.removeFromSuperview()
			tutorialAnimation.resume()
			

			//If we can't jump to this conclusion step, then proceed to the next available conclusion.
			for conclusion in conclusions {
				if conclusion == false {
					continue
				} else {
					break
				}
			}
			
		} else {
			addHint(hint: "Hint", view: getCorrectButton(), timeToAdd: 1.0)
			self.jumpToCondition(named:"Hint")
			resumeTutorialanimation()
		}
		

		pricesQuestions.questionDisplay.isUserInteractionEnabled = false

		
	}
	
	
    override func setupScript() {
        state.addCondition(atTime: 0.0, flagName: "hide") { [weak self] in
            
            self?.pricesTest.priceContainer.isHidden = true
        }
		state.addCondition(atTime: progress(seconds: 0.01), flagName: "prices_prompt") { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.currentHint?.removeFromSuperview()
            weakSelf.pricesTest.priceDisplay.isUserInteractionEnabled = false
            weakSelf.pricesTest.view.overlayView(withShapes: [])
            weakSelf.tutorialAnimation.pause()
            
            self?.currentHint = self?.view.window?.hint {
				$0.content = "".localized(ACTranslationKey.simplified_popup_tutorial_price_intro)
                $0.buttonTitle = "NEXT".localized(ACTranslationKey.popup_tutorial_ready)
                $0.button.addAction {
                    weakSelf.tutorialAnimation.resume()
                    weakSelf.view.window?.clearOverlay()
                    weakSelf.currentHint?.removeFromSuperview()
   
                }
                $0.layout {
                    $0.centerX == weakSelf.view.centerXAnchor
                    $0.centerY == weakSelf.view.centerYAnchor
                    $0.width == 232
                }
            }
        }
        
        state.addCondition(atTime: 0.02, flagName: "init") { [weak self] in
            self?.pricesTest.priceContainer.isHidden = false
            self?.pricesTest.priceDisplay.isHidden = false
            self?.pricesTest.displayItem()
            self?.pricesTest.buildButtonStackView()
            self?.pricesTest.priceContainer.isUserInteractionEnabled = false
        }

        state.addCondition(atTime: progress(seconds: 4), flagName: "question2-0") { [weak self] in
            self?.currentHint?.removeFromSuperview()
            self?.view.clearOverlay()
            self?.pricesTest.nextItem()
            self?.pricesTest.priceDisplay.isUserInteractionEnabled = true
            self?.selectionMade = false
			self?.tutorialAnimation.resume()

        }
        
		state.addCondition(atTime: progress(seconds: 7), flagName: "question2-1") { [weak self] in
				   self?.currentHint?.removeFromSuperview()
				   self?.view.clearOverlay()
				   self?.pricesTest.nextItem()
				   self?.pricesTest.priceDisplay.isUserInteractionEnabled = true
				   self?.selectionMade = false
				   self?.tutorialAnimation.resume()

			   }
		////////////////
		//First question
		////////////////
        state.addCondition(atTime: progress(seconds: 10), flagName: "prices_middle") { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.currentHint?.removeFromSuperview()
            weakSelf.pricesTest.priceContainer.isHidden = true

            weakSelf.pricesTest.priceDisplay.isUserInteractionEnabled = false
            weakSelf.tutorialAnimation.pause()
            weakSelf.progress = 0.25
            self?.currentHint = self?.view.window?.hint {
				$0.content = "*Great!*\nLet's proceed to part two.".localized(ACTranslationKey.popup_tutorial_part2)
				$0.buttonTitle = "NEXT".localized(ACTranslationKey.button_next)
                $0.button.addAction {
                    weakSelf.tutorialAnimation.resume()
                    weakSelf.view.window?.clearOverlay()
					weakSelf.view.window?.removeHighlight()
                    weakSelf.currentHint?.removeFromSuperview()
                    weakSelf.pricesQuestions = weakSelf.pricesTest.preparedQuestionController()
                    weakSelf.pricesQuestions.shouldAutoProceed = false
                    weakSelf.pricesQuestions.delegate = self
                    weakSelf.customView.setContent(viewController: weakSelf.pricesQuestions)
                    weakSelf.pricesQuestions.buildButtonStackView()
                    weakSelf.pricesQuestions.prepareQuestions()
                    weakSelf.pricesQuestions.selectQuestion()
                    weakSelf.pricesQuestions.questionDisplay.isUserInteractionEnabled = true
                    weakSelf.selectionMade = false
                }
                $0.layout {
                    $0.centerX == weakSelf.view.centerXAnchor
                    $0.centerY == weakSelf.view.centerYAnchor
                    $0.width == 232
                }
            }
        }
        
		////////////////
		//First question assist
		////////////////
		state.addCondition(atTime: progress(seconds: 10), flagName: "question3-0") { [weak self] in
            guard let weakSelf = self else {
                return
            }
            guard weakSelf.selectionMade == false else {
                weakSelf.selectionMade = false
                return
            }
			weakSelf.addHint(hint: "Hint", view: weakSelf.getCorrectButton())
            weakSelf.currentHint?.removeFromSuperview()
            weakSelf.pricesQuestions.questionDisplay.isUserInteractionEnabled = true
			
            let shape = OverlayShape.roundedRect(weakSelf.pricesQuestions.questionDisplay, 8, CGSize(width: -8,height:-8))
            weakSelf.pricesQuestions.view.overlayView(withShapes: [shape])
            //weakSelf.tutorialAnimation.pause()
            
            self?.currentHint = self?.view.window?.hint {
                $0.content = "*What do you think?*\nTry your best to recall the price from part one.".localized(ACTranslationKey.popup_tutorial_recall)
                $0.configure(with: IndicatorView.Config(primaryColor: ACColor.hintFill,
                                                        secondaryColor: ACColor.hintFill,
                                                        textColor: .black,
                                                        cornerRadius: 8.0,
                                                        arrowEnabled: true,
                                                        arrowAbove: true))
                $0.updateHintContainerMargins()
                $0.updateTitleStackMargins()
                $0.layout {
                    $0.top == weakSelf.pricesQuestions.questionDisplay.bottomAnchor + 10
                    $0.centerX == weakSelf.pricesQuestions.questionDisplay.centerXAnchor
                    $0.width == weakSelf.pricesQuestions.questionDisplay.widthAnchor
                }
            }
        }
		
		////////////////
		//First question conclusion
		////////////////
		state.addCondition(atTime: progress(seconds: 20.1), flagName: "questions3-0-1") { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.currentHint?.removeFromSuperview()
            weakSelf.tutorialAnimation.pause()
			//weakSelf.getCorrectButton().overlay(radius: 24, inset: CGSize(width: 8	, height: 0))

            weakSelf.pricesQuestions.view.overlayView(withShapes: [])

            weakSelf.progress = 0.5
            self?.currentHint = self?.view.window?.hint {
				$0.content = "*Great choice!*\nLet's try another.".localized(ACTranslationKey.popup_tutorial_greatjob)
                $0.buttonTitle = "NEXT".localized(ACTranslationKey.button_next)
                $0.button.addAction {
					
					////////////////
					//Second question
					////////////////
                    weakSelf.tutorialAnimation.resume()
                    weakSelf.view.window?.clearOverlay()
					weakSelf.view.removeHighlight()
					
                    weakSelf.currentHint?.removeFromSuperview()
                    weakSelf.pricesQuestions.selectQuestion()
                    weakSelf.pricesQuestions.questionDisplay.isUserInteractionEnabled = true
                    weakSelf.selectionMade = false
                    weakSelf.pricesQuestions.topButton.set(selected: false)
                    weakSelf.pricesQuestions.bottomButton.set(selected: false)
                }
                 $0.layout {
								   $0.centerY == weakSelf.pricesQuestions.questionDisplay.centerYAnchor
								   $0.centerX == weakSelf.pricesQuestions.questionDisplay.centerXAnchor
								   $0.width == 232
							   }
            }
        }
        
		////////////////
		//Second question assist
		////////////////
		state.addCondition(atTime: progress(seconds: 30), flagName: "question3-1") { [weak self] in
				   guard let weakSelf = self else {
					   return
				   }
				   guard weakSelf.selectionMade == false else {
					   weakSelf.selectionMade = false
					return
				   }
			weakSelf.addHint(hint: "Hint", view: weakSelf.getCorrectButton())
				   weakSelf.currentHint?.removeFromSuperview()
				   weakSelf.pricesQuestions.questionDisplay.isUserInteractionEnabled = true
				   let shape = OverlayShape.roundedRect(weakSelf.pricesQuestions.questionDisplay, 8, CGSize(width: -8,height:-8))
				   weakSelf.pricesQuestions.view.overlayView(withShapes: [shape])
				   //weakSelf.tutorialAnimation.pause()
//				   weakSelf.pricesQuestions.view.overlayView(withShapes: [])

				   self?.currentHint = self?.view.window?.hint {
					   $0.content = "*What do you think?*\nTry your best to recall the price from part one.".localized(ACTranslationKey.popup_tutorial_choose2)
					   $0.configure(with: IndicatorView.Config(primaryColor: ACColor.hintFill,
															   secondaryColor: ACColor.hintFill,
															   textColor: .black,
															   cornerRadius: 8.0,
															   arrowEnabled: true,
															   arrowAbove: true))
					   $0.updateHintContainerMargins()
					   $0.updateTitleStackMargins()
					   $0.layout {
						   $0.top == weakSelf.pricesQuestions.questionDisplay.bottomAnchor + 10
						   $0.centerX == weakSelf.pricesQuestions.questionDisplay.centerXAnchor
						   $0.width == weakSelf.pricesQuestions.questionDisplay.widthAnchor
					   }
				   }
			   }
		////////////////
		//Second question conclusion
		////////////////
		state.addCondition(atTime: progress(seconds: 40.1), flagName: "questions3-1-1") { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.currentHint?.removeFromSuperview()
            weakSelf.tutorialAnimation.pause()
			//weakSelf.getCorrectButton().overlay(radius: 24, inset: CGSize(width: 8	, height: 0))
			weakSelf.pricesQuestions.view.overlayView(withShapes: [])
			weakSelf.progress = 0.75
            self?.currentHint = self?.view.window?.hint {
				
				$0.content = "*Great choice!*\nLet's try another.".localized(ACTranslationKey.popup_tutorial_nice)
				$0.buttonTitle = "NEXT".localized(ACTranslationKey.button_next)
				////////////////
				//Third question
				////////////////
                $0.button.addAction {
                    weakSelf.tutorialAnimation.resume()
                    weakSelf.view.window?.clearOverlay()
					weakSelf.view.removeHighlight()
                    weakSelf.currentHint?.removeFromSuperview()
                    weakSelf.pricesQuestions.selectQuestion()
                    weakSelf.pricesQuestions.questionDisplay.isUserInteractionEnabled = true
                    weakSelf.selectionMade = false
                    weakSelf.pricesQuestions.topButton.set(selected: false)
                    weakSelf.pricesQuestions.bottomButton.set(selected: false)
                }
                $0.layout {
					$0.centerY == weakSelf.pricesQuestions.questionDisplay.centerYAnchor
					$0.centerX == weakSelf.pricesQuestions.questionDisplay.centerXAnchor
					$0.width == 232
				}
            }
        }
        ////////////////
		//Third question assist
		////////////////
		state.addCondition(atTime: progress(seconds: 50.3), flagName: "question3-2") { [weak self] in
            guard let weakSelf = self else {
                return
            }
            guard weakSelf.selectionMade == false else {
                weakSelf.selectionMade = false

                return
                
            }
			weakSelf.addHint(hint: "Hint", view: weakSelf.getCorrectButton())

            weakSelf.currentHint?.removeFromSuperview()
           
            weakSelf.pricesQuestions.questionDisplay.isUserInteractionEnabled = true
            let shape = OverlayShape.roundedRect(weakSelf.pricesQuestions.questionDisplay, 8, CGSize(width: -8, height: -8))
            //weakSelf.pricesQuestions.view.overlayView(withShapes: [shape])
            
            
            self?.currentHint = self?.view.window?.hint {
                $0.content = "*What do you think?*\nTry your best to recall the price from part one.".localized(ACTranslationKey.popup_tutorial_choose2)
                $0.configure(with: IndicatorView.Config(primaryColor: ACColor.hintFill,
                                                        secondaryColor: ACColor.hintFill,
                                                        textColor: .black,
                                                        cornerRadius: 8.0,
                                                        arrowEnabled: true,
                                                        arrowAbove: true))
                $0.updateHintContainerMargins()
                $0.updateTitleStackMargins()
                $0.layout {
                    $0.top == weakSelf.pricesQuestions.questionDisplay.bottomAnchor + 10
                    $0.centerX == weakSelf.pricesQuestions.questionDisplay.centerXAnchor
                    $0.width == weakSelf.pricesQuestions.questionDisplay.widthAnchor
                }
            }
        }
        
		state.addCondition(atTime: progress(seconds: 60.4), flagName: "end") { [weak self] in
            guard let weakSelf = self else {
                return
            }
            
            weakSelf.finishTutorial()
        }
    }
}
