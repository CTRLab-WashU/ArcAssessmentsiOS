//
//  SurveyViewController.swift
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


open class SurveyViewController: UIViewController, SurveyInput, UIScrollViewDelegate {
	
	var app = Arc.shared
	
	
	public var orientation: UIStackView.Alignment = .center
	
	weak public var surveyInputDelegate:SurveyInputDelegate? {
		get {
			return surveyView.surveyInputDelegate
		}
		set {
			surveyView.surveyInputDelegate = newValue
		}
	}
	
	

	

	
	
	public var helpPressed:(()->())?
	
//    @IBOutlet weak var spacerView: UIView!
    
    var id:String?
    var prompt:String?
    var details:String?
    var input:SurveyInput?
    var questionIndex:String?
    var surveyId:String?
	public var surveyView:SurveyView {
		return view as! SurveyView
	}
    private var controller = Arc.shared.surveyController

//    @IBAction func nextButtonPressed(_ sender: Any) {
//
//			let value = input?.getValue()
//
//            nextPressed?(input, value)
//    }
	open override func loadView() {
		super.loadView()
		let v = SurveyView()
		input = v
		self.view = v
	}
	
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let nav = self.navigationController, nav.viewControllers.count > 1 {
            let backButton = UIButton(type: .custom)
            backButton.frame = CGRect(x: 0, y: 0, width: 60, height: 10)
            backButton.setImage(Arc.shared.image(named: "cut-ups/icons/arrow_left_blue"), for: .normal)
            backButton.setTitle("BACK".localized(ACTranslationKey.button_back), for: .normal)
            backButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 14)
            backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
            backButton.setTitleColor(ACColor.primary, for: .normal)
            backButton.addTarget(self, action: #selector(self.backPressed), for: .touchUpInside)

//            NSLayoutConstraint(item: backButton, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: super.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: -75).isActive = true
            let leftButton = UIBarButtonItem(customView: backButton)

            //self.navigationItem.setLeftBarButton(leftButton, animated: true)
            self.navigationItem.leftBarButtonItem = leftButton
            
			
		}
        
		

    }
	
	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = view.backgroundColor
        
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        scrollIndicatorState(scrollView)
//		if scrollView.contentSize.height > scrollView.bounds.height && !(input is SignatureView){
//			scrollView.delaysContentTouches = true
//
//		} else {
//			scrollView.delaysContentTouches = false
//		}
		
    }

    
    @objc func backPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func set(questionIndex:String) {
        
       self.questionIndex = questionIndex
    }
    func loadQuestion(questionIndex:String) {
        let question = controller.get(question: questionIndex)
		
		displayQuestion(question: question)
		
    }
	
	// MARK: - Question Display
	/// Display Question sets the main prompt text, detail text, and input for a question.
	/// The button text is also handled via the question data along with other metadata for specific settings.
	///
	/// - Parameter question: An object of type Survey.Question.
	/// This value is created via Json files loaded by the parent SurveyNavigationViewController
	func displayQuestion(question:Survey.Question) {
		
		let template = surveyInputDelegate?.templateForQuestion(id: question.questionId) ?? [:]
		
		surveyView.displayQuestion(withQuestion: question, template: template)

	}
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadQuestion(questionIndex: questionIndex ?? "")

       	surveyInputDelegate?.didFinishSetup()
        
    }
	public func getValue() -> QuestionResponse? {
		return input?.getValue()
	}
	
	public func setValue(_ value: QuestionResponse?) {
		input?.setValue(value)
	}
	
	
	public func setError(message: String?) {
        
//        if message != nil && (self.input is PasswordView || self.input is SegmentedTextView) {
//            showContactButton()
//        } else {
//            showContactButton(false)
//        }
		input?.setError(message: message)
	}
	
    public func enableNextButton()
    {
		
        if let id = self.id, let title = Arc.shared.surveyController.get(question: id).altNextButtonTitle {
            surveyView.enableNextButton(title: title)
        }
    }
    
    public func disableNextButton()
    {
		
        if let id = self.id, let title = Arc.shared.surveyController.get(question: id).nextButtonTitle {
			surveyView.disableNextButton(title: title)
        }
    }
    
    
    @IBAction public func goToPrivacy() {
        app.appNavigation.defaultPrivacy()
    }

	
    
    @objc open func navigateToHelp() {
		if let helpPressed = helpPressed {
			helpPressed()
		} else {
            app.appNavigation.navigate(vc: app.appNavigation.defaultHelpState(), direction: .toRight)
		}
    }
	
	
	
	
	
	
}
