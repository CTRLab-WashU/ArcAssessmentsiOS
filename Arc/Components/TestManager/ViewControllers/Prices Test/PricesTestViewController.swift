//
//  PricesTestViewController.swift
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

public protocol PricesTestDelegate : class {
	func didSelectGoodPrice(_ option:Int)
	func didSelectPrice(_ option:Int)
	func shouldEndTest() -> Bool

}
public class PricesTestViewController: ArcViewController {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var goodPriceLabel: UILabel!
	@IBOutlet weak var priceDisplay: UIStackView!
	@IBOutlet weak var priceContainer: ACView!
	
    @IBOutlet weak var buttonStack: UIStackView!
    private var questionDisplay:PricesQuestionViewController?
	public var questionAlignment:NSTextAlignment = .left
    var controller = Arc.shared.pricesTestController
    var test:PriceTest?
    var responseID = ""
	var autoStart = true
    var hasCompleted = false
    public var isPracticeTest = false
	weak var delegate:PricesTestDelegate?
    public static var testVersion:String {
        
        return Arc.shared.appController.locale.availablePriceTest
        
        
        
    }
    var isTutorial:Bool = false
	public static var tutorialVersion:String {
		return "priceSets-en-US-tutorial"
	}
//    private var questionDisplay:DNPricesQuestionViewController?
//    private var test:DNPricesTest?
    private var itemIndex = 0
    private var questionIndex = 0
    private var flippedPrices:Set<Int>! = nil
    var displayTimer:Timer?;
    
    // Buttons
    private var views:[ChoiceView] = []
    let topButton:ChoiceView = .get()
    let bottomButton:ChoiceView = .get()
    

    override open func viewDidLoad() {
        self.cancelButtonModalUseLightTint = false
        super.viewDidLoad()
		if !autoStart && !isPracticeTest {
        	ACState.testCount += 1
		}

		if autoStart {
            let sessionId = Int(Arc.shared.appController.currentSessionID)
            test = controller.loadTest(index: sessionId, file: PricesTestViewController.testVersion )
            self.isTutorial = false
            responseID = controller.createResponse(withTest: test!)
			
			//Selecte a group of question indicies such that then they are displayed,
			//they will be flipped.
			
		} else {
			let controller =  Arc.shared.pricesTestController
			test = controller.loadTest(index: 0,
												file: PricesTestViewController.tutorialVersion)
            self.isTutorial = true
			
			responseID = controller.createResponse(withTest: test!)
		}
		
		if flippedPrices == nil
		{
			let count = controller.get(testCount: responseID)
			flippedPrices = Set<Int>.uniqueSet(numberOfItems: count / 2, maxValue: count)
		}
		
		//Based on the type certain mods will be applied.
		Arc.environment?.priceTestType.applyMods(viewController: self)
		
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Because of the way this VC shows the PricesQuestion afterwards,
        // viewDidAppear can be called when dismissing the navigation stack
        // To avoid auto start kicking off the process again, return here
        if (self.hasCompleted) {
            return
        }
        
        _ = controller.start(test: responseID)
		_  = controller.mark(filled: responseID)
		if autoStart {
			priceDisplay.isHidden = false
            displayItem()
			buildButtonStackView()
		}
    }
	public override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		displayTimer?.invalidate()
	}
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	public func nextStep() {
		itemIndex += 1
	}
	
	@objc func nextItem()
    {
        nextStep()
		
        displayItem();
    }
	
	/// Invalidates the display timer, deselects all buttons for reuse,
	/// and ensures that user interaction is enabled.
	public func resetController() {
		displayTimer?.invalidate();
		
        topButton.set(selected: false);
		topButton.isUserInteractionEnabled = true;
		bottomButton.set(selected: false);
		bottomButton.isUserInteractionEnabled = true;
	}
	
	/// Displays a question stimuli and asks the user to confirm if the price is good or not.
	/// - Parameter index: The index is fed into the controller powering the test and used
	/// to retrieve a question from the selected test.
	/// - Parameter isTimed: Defaulting to true, this will cause the test to only display the stimuli for a limited period of time.
	public func displayPrice(index:Int, isTimed:Bool = true) {
		
		guard let item = controller.get(question: index, id: responseID) else {
			return
		}
		let topLabel = (flippedPrices.contains(itemIndex)) ? itemNameLabel : itemPriceLabel
		let bottomLabel = (topLabel == itemNameLabel) ? itemPriceLabel : itemNameLabel
		
		topLabel?.text = item.item
		
        var correctPrice = "".localized(ACTranslationKey.money_prefix) + item.price + "".localized(ACTranslationKey.money_suffix)
        if self.isTutorial {
            correctPrice = item.price
        }
		bottomLabel?.text = correctPrice
		
		bottomLabel?.resizeFontForSingleWords();
		topLabel?.resizeFontForSingleWords();
		
		_ = controller.mark(stimulusDisplayTime: responseID, index: index)
		if isTimed {
			displayTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(nextItem), userInfo: nil, repeats: false)
		}
	}
	public func preparedQuestionController() -> PricesQuestionViewController{
		//Present controller
		questionDisplay = .get()
        questionDisplay?.cancelButtomModal = self.cancelButtomModal
		questionDisplay?.modalPresentationStyle = .fullScreen
		questionDisplay?.questionAlignment = questionAlignment

		questionDisplay?.responseId = responseID
        questionDisplay?.isTutorial = self.isTutorial
//		questionDisplay?.selectQuestion()
		return questionDisplay!
	}

	/// Displays the recall portion of the test. This controller is not timed.
	/// As the user makes selections the test will progress and track their
	/// response time.
	public func showQuestionController(alertView:MHAlertView) {
		//Present controller
		questionDisplay = .get()
        questionDisplay?.cancelButtomModal = self.cancelButtomModal
		questionDisplay?.modalPresentationStyle = .fullScreen
		questionDisplay?.questionAlignment = questionAlignment
		questionDisplay?.responseId = responseID
		present(questionDisplay!, animated: false, completion: { [weak self] in
			guard let weakself = self else {
				return
			}
			
			weakself.questionDisplay?.selectQuestion()
		})
		alertView.removeFromSuperview()
		
	}
	
	/// Display an alert telling the user that the recall portion of the test will begin.
	/// They can either wait 12 seconds or after 3 seconds hit the begin button to begin
	/// the next phase of the test.
	public func displayTransition() {
		Arc.shared.displayAlert(message: "You will now start the test.\nYou will see an item and two prices. Please select the price that matches the item you studied.".localized(ACTranslationKey.prices_overlay), options: [
			
			.delayed(name: "BEGIN".localized(ACTranslationKey.button_begin), delayTime: 3.0, showQuestionController),
			
			.wait(waitTime: 12.0, showQuestionController)
			
		])
	}
	
	/// Hide the buttons and remove all text from the display
	/// this will prevent the user from seeing stimuli for too long.
	public func hideInterface() {
		self.topButton.isHidden = true;
		self.bottomButton.isHidden = true;
		self.goodPriceLabel.isHidden = true;
		self.itemNameLabel.text = ""
		self.itemPriceLabel.text = ""
	}
	
	func displayItem()
	{
		//Reset the state of the top and bottom selection bottons
		resetController()
		
		
		//If our item index is less than the number of items in this particular
		//run of the prices test we can safely display the price at that index
        if itemIndex < controller.get(testCount: responseID)
		{
			displayPrice(index: itemIndex, isTimed:autoStart)
        }
		//Else we've reached the end of the first phase of the test
		else
		{
			
			displayTransition()
            
			hideInterface()
            
            self.hasCompleted = true
        }
        
    }
    
    func buildButtonStackView() {
        topButton.set(message: "Yes".localized(ACTranslationKey.radio_yes).capitalized)
        bottomButton.set(message: "No".localized(ACTranslationKey.radio_no).capitalized)
        
        topButton.needsImmediateResponse = true
        bottomButton.needsImmediateResponse = true
        
        topButton.button.titleLabel?.numberOfLines = 1
        bottomButton.button.titleLabel?.numberOfLines = 1
        
        topButton.set(state: .radio)
        bottomButton.set(state: .radio)
        
        topButton.tapped = {
            [weak self] view in
            self?.yesPressed()
        }
        
        bottomButton.tapped = {
            [weak self] view in
            self?.noPressed()
        }
        
        views.append(topButton)
        views.append(bottomButton)
        buttonStack.addArrangedSubview(topButton)
        buttonStack.addArrangedSubview(bottomButton)
    }
    
    func yesPressed() {
        if itemIndex < controller.get(testCount: responseID) {
            
            topButton.set(selected: true)
            bottomButton.set(selected: false)
            
            _ = controller.set(goodPrice: 1, id: responseID, index: itemIndex)
			delegate?.didSelectGoodPrice(1)

        }
    }
    
    func noPressed() {
        if itemIndex < controller.get(testCount: responseID) {
            
            topButton.set(selected: false)
            bottomButton.set(selected: true)
            
            _ = controller.set(goodPrice: 0, id: responseID, index: itemIndex)
			delegate?.didSelectGoodPrice(0)
        }
    }
    
}



