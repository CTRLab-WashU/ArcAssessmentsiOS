//
//  SymbolsTestViewController.swift
// Arc
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


public protocol SymbolsTestViewControllerDelegate : class {
	func didSelect(index:Int)
}
public class SymbolsTestViewController: ArcViewController, TestProgressViewControllerDelegate {
	
	
    public var symbols:[Int:UIImage] = [
        0: Arc.shared.image(named: "symbol_0")!,
        1: Arc.shared.image(named: "symbol_1")!,
        2: Arc.shared.image(named: "symbol_2")!,
        3: Arc.shared.image(named: "symbol_3")!,
        4: Arc.shared.image(named: "symbol_4")!,
        5: Arc.shared.image(named: "symbol_5")!,
        6: Arc.shared.image(named: "symbol_6")!,
        7: Arc.shared.image(named: "symbol_7")!]
    
    var controller = Arc.shared.symbolsTestController
    var responseID = ""
    var questionIndex = 0
    @IBOutlet public weak var option1: UIView!
    @IBOutlet public weak var option2: UIView!
    @IBOutlet public weak var option3: UIView!
    @IBOutlet public weak var tileHeight:NSLayoutConstraint?
	
	@IBOutlet weak var selectionContainer: UIView!
	
    @IBOutlet weak var promptLabel: ACLabel!
	@IBOutlet public weak var choiceContainer: UIView!
    
    // Optional since the tutorial view controller does not show button tapsr
    @IBOutlet public weak var choice1OnClick: UIView?
    @IBOutlet public weak var choice2OnClick: UIView?
    
    @IBOutlet public weak var choice1: UIView!
    @IBOutlet public weak var choice2: UIView!
	public var isPracticeTest:Bool = false
	public weak var delegate:SymbolsTestViewControllerDelegate?
//    private var currentTrialData:DNSymbolInputData!
    private var test:SymbolsTest?
    
	public var correctSelection:(UIView,UIView)? {
		get {
			let correct = test!.sections[questionIndex].correct - 1
			guard let option = test!.sections[questionIndex].options.firstIndex (where: {
				$0 == test!.sections[questionIndex].choices[correct]
			}) else { return nil }
			
			guard let optionView = [option1, option2, option3][option] else {
				return nil
			}
            return (correct == 0) ? (choice1, optionView) : (choice2, optionView)
		}
		set {
			
		}
	}
    
    override open func viewDidLoad() {
        self.cancelButtonModalUseLightTint = false
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Create the test optionally with a duration
		if !isPracticeTest {
        	ACState.testCount += 1
		}

		if !isPracticeTest {
			test = controller.generateTest(numSections: 12, numSymbols: 8)
			responseID = controller.createResponse(withTest: test!)
		} else {
			// Will be stored in core data, but not retrieved for server upload.
            test = controller.generateTutorialTest()
        	responseID = controller.createResponse(withTest: test!)
		}
        
        let gradient = CAGradientLayer()
        if !isPracticeTest {
            gradient.frame = choice2.bounds
            gradient.colors = [UIColor.white.cgColor, UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0).cgColor]
        } else {
            gradient.frame = self.view.bounds
            gradient.colors = [UIColor.white.cgColor, UIColor(red: 99.0/255.0, green: 102.0/255.0, blue: 107.0/255.0, alpha: 1.0).cgColor]
        }
        choice1.layer.insertSublayer(gradient, at: 0)
        
        let gradient2 = CAGradientLayer()
        if !isPracticeTest {
        gradient2.frame = choice2.bounds
        gradient2.colors = [UIColor.white.cgColor, UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0).cgColor]
        } else {
            gradient2.frame = self.view.bounds
            gradient2.colors = [UIColor.white.cgColor, UIColor(red: 99.0/255.0, green: 102.0/255.0, blue: 107.0/255.0, alpha: 1.0).cgColor]
        }
        choice2.layer.insertSublayer(gradient2, at: 0)
        
        self.setTileHeight()
    }
    func setTileHeight() {
        switch PhoneClass.getClass() {
        case .iphone678:
            self.tileHeight?.constant = 164
        case .iphone678Plus, .iphoneXR, .iphoneX, .iphoneMax:
            self.tileHeight?.constant = 192
        default:
            return
        }
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
		if isPracticeTest {
			layoutOptionsAndChoices()
            
            option1.alpha = 0
            option2.alpha = 0
            option3.alpha = 0
            
            choice1.alpha = 0
            choice2.alpha = 0
            
		}
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //Trigger the begining of the test

        _ = controller.start(test: responseID)
		_  = controller.mark(filled: responseID)

		if !isPracticeTest {
			layoutOptionsAndChoices()
		}
        
        self.choice1OnClick?.isHidden = true
        self.choice1OnClick?.layer.cornerRadius = 2
        self.choice2OnClick?.isHidden = true
        self.choice2OnClick?.layer.cornerRadius = 2
    }
    public func layoutOptionsAndChoices(){
        
        let choicesAndOptions = test!.sections[questionIndex]
        
        //Set each of the options
        configureOption(view: option1, symbolSet: choicesAndOptions.options[0])
        configureOption(view: option2, symbolSet: choicesAndOptions.options[1])
        configureOption(view: option3, symbolSet: choicesAndOptions.options[2])
		
        //Set each of the tappable choices
        configureOption(view: choice1, symbolSet: choicesAndOptions.choices[0])
        configureOption(view: choice2, symbolSet: choicesAndOptions.choices[1])
		
        
        _ = controller.mark(appearanceTimeForQuestion: questionIndex, id: responseID)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func getSymbol(index:Int) -> UIImage {
        let img = self.symbols[index]!
        return img.copy() as! UIImage;
    }
    
    func configureOption(view:UIView, symbolSet:SymbolsTest.SymbolSet){
        guard let top = view.viewWithTag(1) as? UIImageView else {
            return
        }
        guard let bottom = view.viewWithTag(2)as? UIImageView else {            
            return
        }
        top.image = getSymbol(index: symbolSet.symbols[0])
        bottom.image = getSymbol(index: symbolSet.symbols[1])
		
    }
    @IBAction func optionSelected(_ sender: SymbolSelectButton) {
        
        // When video recording this test for data validation, we need to have
        // have visual feedback which symbol was tapped
        if (sender.superview == choice1) {
            self.choice1OnClick?.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: (.now() + 0.1), execute: { [weak self] in
                self?.choice1OnClick?.isHidden = true
            })
        } else if (sender.superview == choice2) {
            self.choice2OnClick?.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: (.now() + 0.1), execute: { [weak self] in
                self?.choice2OnClick?.isHidden = true
            })
        }
        
		if !isPracticeTest {
        	_ = controller.mark(timeTouched: questionIndex, date:sender.touchTime!, id: responseID)
        	let _ = controller.set(choice: sender.tag, forQueston: questionIndex, id: responseID)
		}
		
//        currentTrialData.touchLocation = sender.touchLocation! //this doesn't appear in the data for current tests
//        print(p!.toString())
//        test?.touchLocations.append(sender.touchLocation!);
//        test?.touchTimes.append(sender.touchTime!);
//        test?.selectValue(option: currentTrialData as AnyObject?)
        delegate?.didSelect(index: sender.tag)
        if questionIndex >= controller.get(questionCount: responseID) - 1 {
			if !isPracticeTest {
				_  = controller.mark(filled: responseID)

                let nextMessage = (ACState.testCount == 3 || ACState.totalTestCountInSession == 1) ? "Well done!".localized(ACTranslationKey.testing_done) : "Loading next test...".localized(ACTranslationKey.testing_loading)
				let vc = TestProgressViewController(title: "Symbols Test Complete!".localized(ACTranslationKey.symbols_complete), subTitle: nextMessage, count: ACState.testTaken - 1, maxCount: ACState.totalTestCountInSession)
				vc.delegate = self
				self.addChild(vc)
				self.view.anchor(view: vc.view)
				vc.set(count: ACState.testTaken)
				vc.waitAndExit(time: 3.0)
			}
            
        }
        else
        {
			if !isPracticeTest {
				next()
			}
        }
        
    }
	
	public func testProgressDidComplete() {
		if !isPracticeTest {
	
			Arc.shared.nextAvailableState()
		}
	}
	public func next() {
		questionIndex += 1
		layoutOptionsAndChoices();
	}
    
}
