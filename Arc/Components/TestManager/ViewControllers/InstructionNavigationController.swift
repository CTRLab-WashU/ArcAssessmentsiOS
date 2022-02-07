//
//  TestNavigationController.swift
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

open class InstructionNavigationController: UINavigationController, SurveyInputDelegate {
	
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
	
	var app = Arc.shared
	public var instructions:[Survey.Question]?
	public var nextVc:UIViewController?
	public var nextState:State?
	public var titleOverride:String?
	var currentIndex:Int = 0
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		_ = displayIntro(index: 0)

    }
	@discardableResult
	open func load(instructions template:String) -> Survey {
        guard let asset = Arc.shared.dataAsset(named: template) else {
			fatalError("Missing data asset: \(template)")
		}
		do {
			let intro = try JSONDecoder().decode(Survey.self, from: asset.data)
			instructions = intro.questions

			return intro
		} catch {
			fatalError("Invalid asset format: \(template) - Error: \(error.localizedDescription)")
			
		}
	}
	
	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	public func didChangeValue() {
		
	}
	
	public func nextPressed(input:SurveyInput?, value:QuestionResponse?) {
		self.next(nextQuestion: currentIndex)
	}
	
	public func valueSelected(value: QuestionResponse, index: String) {
		
	}
	
	public func templateForQuestion(id: String) -> Dictionary<String, String> {
		return [:]
	}
	
	public func didPresentQuestion(input: SurveyInput?) {
		
	}
	
	public func didFinishSetup() {
		
	}
	public func tryNextPressed() {
		
	}
	
	private func displayIntro(index:Int) -> Bool {
		
		if let instructions = instructions,
			index < instructions.count
		{
			let instruction = instructions[index]
			let vc:IntroViewController = IntroViewController()
			vc.style = IntroViewControllerStyle(rawValue: instruction.style?.rawValue ?? "standard")!
			vc.loadViewIfNeeded()
			vc.nextButtonTitle = instruction.nextButtonTitle
            vc.nextButtonImage = instruction.nextButtonImage
			self.pushViewController(vc, animated: true)
//
			vc.set(heading:     titleOverride ?? instruction.title,
				   subheading:  instruction.subTitle,
				   content:     instruction.prompt)
			vc.inputDelegate = self
			
			return true
		}
		return false
	}
	private func next(nextQuestion: Int) {
		if displayIntro(index: self.viewControllers.count) {
			
		} else {
			
			
			//Subclasses may perform conditional async operations
			//that determine if the app should proceed.
			if let nextState = self.nextState {
				app.appNavigation.navigate(state: nextState, direction: .toRight)
			} else {
				if let vc = nextVc {
					let countVc = TestCountDownViewController(nextVc: vc)
					app.appNavigation.navigate(vc: countVc, direction: .toRight)

				} else {
					fatalError("Failed to set either state or view controller.")
				}

			}
		}
	}
	open override func popViewController(animated: Bool) -> UIViewController? {
		currentIndex = viewControllers.count - 1
		print(currentIndex)
		
		return super.popViewController(animated: animated)
		
	}
	open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		super.pushViewController(viewController, animated: animated)
		
		currentIndex = viewControllers.count - 1
		print(currentIndex)
		
	}

}
