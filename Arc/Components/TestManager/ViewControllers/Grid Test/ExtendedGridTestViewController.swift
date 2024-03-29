//
//  ExtendedGridTestViewController.swift
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

public protocol ExtendedGridTestViewControllerDelegate : class {
	func didSelectGrid(indexPath:IndexPath)
	func didSelectLetter(indexPath:IndexPath)
	func didDeselectLetter(indexPath:IndexPath)
    func didUpdateIndicator(indexPath:IndexPath, indicator:IndicatorView?)
}
open class ExtendedGridTestViewController: ArcViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TestProgressViewControllerDelegate {
	
	
    public enum Mode {
        case none
        case image
        case fCell
		case answers
    }
    
   
    public var mode:Mode = .none
    
    public var choiceIndicator:IndicatorView?
    public var gridChoice:GridChoiceView?
    public var controller = Arc.shared.gridTestController
    public var tests:[GridTest] = []
    public var responseId:String = ""
    public var testNumber:Int = 0
    public var phase:Int = 0
    public var endTimer:Timer?
    public var maybeEndTimer:Timer?
	public var isVisible = true
	public var shouldAutoProceed = true
    public var isPracticeTest = false
	public var fIndexPaths:[IndexPath] = []
	public var symbolIndexPaths:[IndexPath] = []
    var interstitial:InterstitialView = .get()
    @IBOutlet public weak var collectionStack: UIStackView!
    @IBOutlet public weak var collectionView: UICollectionView!
    @IBOutlet public weak var collectionViewHeight:NSLayoutConstraint!
    @IBOutlet public weak var tapOnTheFsLabel: ACLabel!
    @IBOutlet public weak var collectionViewWidth: NSLayoutConstraint!
    @IBOutlet public weak var continueButton: ACButton!
	public weak var delegate:ExtendedGridTestViewControllerDelegate?
    private var symbols:[UIImage] = [Arc.shared.image(named: "key")!,
                                     Arc.shared.image(named: "phone")!,
                                     Arc.shared.image(named: "pen")!]
    public var selected = 0
    public var maxSelected = 3
	public var revealedIndexPaths:[IndexPath] = []
	
    private var IMAGE_HEIGHT:Int {
        get {
            return SMALLER_GRIDS ? 58 : 80
        }
    }
    private var IMAGE_WIDTH:Int {
        get {
            return SMALLER_GRIDS ? 48 : 60
        }
    }
    private var SMALLER_GRIDS:Bool {
        get {
            //return (self.isPracticeTest && (PhoneClass.getClass() == .iphoneSE))
            return (PhoneClass.getClass() == .iphoneSE)
        }
    }
    private let IMAGE_ROWS = 5
    private let IMAGE_LINE_SPACING = 3
    private var IMAGE_BUFFER = 8
    private let LETTER_SIZE = 42
    private let LETTER_ROWS = 10
    private var LETTER_BUFFER = 20
    private let LETTER_LINE_SPACING = 1
    private let IMAGE_GRID_TUTORIAL_WIDTH:CGFloat = 280
    private let LETTER_GRID_TUTORIAL_WIDTH:CGFloat = 284

	private weak var currentAlert:MHAlertView?
    override open func viewDidLoad() {
        self.cancelButtonModalUseLightTint = false
        super.viewDidLoad()
		if shouldAutoProceed && !isPracticeTest {
        	ACState.testCount += 1
		}
        
        if !isPracticeTest {
        	tests = controller.createTest(numberOfTests: 2)
        	responseId = controller.createResponse(numSections: 2)
        } else {
            tests = controller.createTutorialTest()
            responseId = controller.createResponse(numSections: 1)
        }
		collectionView.register(UINib(nibName: "GridFCell", bundle: Bundle.module), forCellWithReuseIdentifier: "fCell")
		collectionView.register(UINib(nibName: "GridImageCell", bundle: Bundle.module), forCellWithReuseIdentifier: "imageCell")

        // Do any additional setup after loading the view.
        
//        if let h = UIApplication.shared.keyWindow?.rootViewController?.view.frame.height, h > 568 {
//            LETTER_BUFFER = 60
//        }
		continueButton.isHidden = true
		let _ = controller.set(symbols: responseId, gridTests: tests)
        tapOnTheFsLabel.isHidden = true
        
        
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		isVisible = true

			
		_ = controller.start(test: responseId)
		_  = controller.mark(filled: responseId)

		if shouldAutoProceed {
			displayPreSymbols();
		}
    }
	open override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		isVisible = false
        maybeEndTimer?.invalidate()
        maybeEndTimer = nil
		currentAlert?.remove()
	}
    open func displaySymbols()
    {
		guard isVisible else {
			return
		}
        choiceIndicator?.removeFromSuperview()
        
        continueButton.isHidden = true
        
//        self.collectionViewHeight.constant = CGFloat((IMAGE_HEIGHT*IMAGE_ROWS) + (IMAGE_LINE_SPACING*(IMAGE_ROWS-1)) + IMAGE_BUFFER)
        if SMALLER_GRIDS {
            self.collectionViewWidth.constant = IMAGE_GRID_TUTORIAL_WIDTH
        }
        
        
        interstitial.set(message: nil)
        interstitial.removeFromSuperview()
        self.mode = .image
        
        endTimer?.invalidate();
        
        phase = 0;
        
        collectionView.allowsSelection = false;
        symbolIndexPaths = []
        collectionView.reloadData();
        
        _ = controller.markTime(gridDisplayedSymbols: responseId, questionIndex: testNumber)
       
		if shouldAutoProceed {
			Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {
				[weak self] (timer) in
				self?.displayFs()
			}
		}
        
        if !isPracticeTest{
            collectionView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 4).isActive = true
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: 4).isActive = true
        }  else {
            collectionView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 4).isActive = true
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: 4).isActive = true
            self.view.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        }
        self.collectionViewHeight.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    open func displayFs()
    {
		guard isVisible else {
			return
		}

        if !isPracticeTest{
            collectionView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 4).isActive = true
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: 4).isActive = true
        }
        self.mode = .fCell

        phase = 1

        collectionView.allowsSelection = true

        collectionView.allowsMultipleSelection = true
		fIndexPaths = []
        collectionView.reloadData()

        _ = controller.markTime(gridDisplayedFs: responseId, questionIndex: testNumber)
        
        tapOnTheFsLabel.isHidden = false
		tapOnTheFsLabel.translationKey = "grids_subheader_fs"
        tapOnTheFsLabel.text = "Tap on the F's"
        tapOnTheFsLabel.numberOfLines = 0
        
		if shouldAutoProceed {

			Timer.scheduledTimer(withTimeInterval: 8, repeats: false) {[weak self] (timer) in
				self?.displayReady()
			}
		}
        
       // self.collectionViewHeight.constant = ((6/10) * self.collectionView.collectionViewLayout.collectionViewContentSize.height)
        view.layoutSubviews()
        self.collectionViewHeight.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
    }
	open func clearGrids()
	{
		guard isVisible else {
			return
		}
		
        choiceIndicator?.removeFromSuperview()

		self.mode = .none
		
		phase = 0
		
		collectionView.allowsSelection = false
		
		collectionView.allowsMultipleSelection = false
		fIndexPaths = []
		collectionView.reloadData()
		
		
		tapOnTheFsLabel.isHidden = false
		
        self.currentHint?.removeFromSuperview()
        self.currentHint = nil

		
	}
    
    open func displayReady()
    {
        
        guard isVisible else {
            return
        }
        
        Arc.shared.displayAlert(message: "".localized(ACTranslationKey.grids_overlay3), options: [
            .wait(waitTime: 2.0, {
            
                $0.set(message:"".localized(ACTranslationKey.grids_overlay3_pt2))
        }),
        .wait(waitTime: 4.0, {
            [weak self] in
            self?.displayGrid()
            if let s = self {
                s.tapOnTheFsLabel.isHidden = true
            }
            $0.removeFromSuperview()
        })])
    }
    
    open func displayPreSymbols()
    {
		guard isVisible else {
			return
		}
		self.tapOnTheFsLabel.isHidden = true
        continueButton.isHidden = true
        currentAlert = Arc.shared.displayAlert(message: "".localized(ACTranslationKey.grids_overlay1),
									options: [.wait(waitTime: 2.0, {
										self.displaySymbols()
										$0.removeFromSuperview()
									})])

		
    }
    
    open func displayGrid()
    {
		guard isVisible else {
			return
		}
        
        interstitial.set(message: nil)
        interstitial.removeFromSuperview()

        mode = .image
        
        collectionView.allowsSelection = true;
        selected = 0
        tapOnTheFsLabel.isHidden = false
        tapOnTheFsLabel.translationKey = nil
        tapOnTheFsLabel.numberOfLines = 0
        if isPracticeTest {
			tapOnTheFsLabel.text = "Tap the boxes where the items were located in part one.".localized(ACTranslationKey.popup_tutorial_subheader)
        } else {
            tapOnTheFsLabel.text = "Tap on the locations of the items.".localized(ACTranslationKey.grids_tutorial_vb_tap_locations)
            collectionView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 4).isActive = true
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: 4).isActive = true
        }
        
        collectionView.allowsMultipleSelection = true;
        
        phase = 2
        
        collectionView.reloadData()
        
        _ = controller.markTime(gridDisplayedTestGrid: responseId, questionIndex: testNumber)
		if shouldAutoProceed {

        	endTimer = Timer.scheduledTimer(timeInterval: 40, target: self, selector: #selector(endTest), userInfo: nil, repeats: false)
		}
        
        view.layoutSubviews()
        collectionViewHeight.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    @IBAction func continuePressed(_ sender: Any)
    {
        if !isPracticeTest{
            maybeEndTest()
        }
    }
    
    @objc open  func endTest()
    {
        if phase == 3
        {
            return;
        }
        
        phase = 3
        
        testNumber += 1;
        
//        test?.selectValue(option: gridData as AnyObject?);
		
//        gridData = DNGridInputSet(selectedFs: 0, selectedEs: 0, selectedGridItems: []);
        
//        test?.gridTestMetrics.append(self.gridMetrics);
        
//        self.gridMetrics = DNGridTestMetrics();
        
        if testNumber >= controller.get(testCount: responseId)
        {
			_ = controller.mark(filled: responseId)
			let nextMessage = (ACState.testCount == 3 || ACState.totalTestCountInSession == 1) ? "Well done!".localized(ACTranslationKey.testing_done) : "Loading next test...".localized(ACTranslationKey.testing_loading)
			let vc = TestProgressViewController(title: "Grids Test Complete!".localized(ACTranslationKey.grids_complete), subTitle: nextMessage, count: ACState.testTaken - 1, maxCount: ACState.totalTestCountInSession)
			vc.delegate = self
			self.addChild(vc)
			self.view.anchor(view: vc.view)
			vc.set(count: ACState.testTaken)
			vc.waitAndExit(time: 3.0)
			
        }
        else
        {
            displayPreSymbols();
        }
        
    }
	public func testProgressDidComplete() {
		Arc.shared.nextAvailableState()

	}
    open func maybeEndTest()
    {
        if controller.get(numChoicesFor: responseId, testIndex: testNumber) >= 3
        {
            endTimer?.invalidate();
            endTest();
        }
    }
    
    // Sets numbers of cells for each grids test portion
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch mode {
        case .image, .answers:
            return 25

        case .fCell:
            return 54
        default:
            return 0
        }
        
    }
    
    // Sets images and f's for cell with value
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = (mode == .image) ? "imageCell" : "fCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type, for: indexPath)
        let index = indexPath.row
        
        if (mode == .image || mode == .answers) {
            
            let iCell = cell as! GridImageCell
            iCell.clear()
            iCell.layer.cornerRadius = 4
            iCell.layer.borderWidth = 1
            iCell.layer.borderColor = UIColor(red: 133.0/255.0, green: 141/255.0, blue: 145.0/255.0, alpha: 1.0).cgColor
            iCell.isPracticeCell = self.isPracticeTest
            
            if mode != .answers && !self.isPracticeTest {
            	iCell.image.isHidden = false;
			} else {
				if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false{
					iCell.image.isHidden = true
				}
 			}
			if phase == 0 {
                let value = controller.get(item: index, section: testNumber, gridType: .image)
                if value > -1 {
                    iCell.setImage(image: self.symbols[value]);
                    iCell.image.isHidden = false;
                    symbolIndexPaths.append(indexPath)
                }
            } else if (self.isPracticeTest && phase == 2) {
                 if let selection = controller.get(selectedData: index, id: responseId, questionIndex: testNumber, gridType: .image)?.selection {
                        iCell.setImage(image:self.symbols[selection])
                        iCell.image.isHidden = false
                    }
            } else if phase == 2 {
                if let selection = controller.get(selectedData: index, id: responseId, questionIndex: testNumber, gridType: .image)?.selection {
                        iCell.setImage(image:self.symbols[selection])
                        iCell.image.isHidden = false
                }
                if controller.get(numChoicesFor: responseId, testIndex: testNumber) == 3
                {
                    continueButton.isHidden = false
                    collectionStack.setCustomSpacing(8, after: tapOnTheFsLabel)
                } else {
                    continueButton.isHidden = true
                }
            }
                            
            
        } else if (mode == .fCell) {
            let fCell = cell as! GridFCell
            var radius = ((UIScreen.main.bounds.size.width - 44)/6) / 2
            if SMALLER_GRIDS {
                radius = ((collectionViewWidth.constant)/6) / 2
            }
            fCell.contentView.layer.cornerRadius = radius
            fCell.contentView.layer.backgroundColor = UIColor.clear.cgColor;
            fCell.contentView.layer.masksToBounds = true
            
            let value = controller.get(item: index, section: testNumber, gridType: .distraction)

            if value == 1 {
                fCell.setCharacter(character: "F")
				fIndexPaths.append(indexPath)

            }
            else
            {
                fCell.setCharacter(character: "E");
            }
        }
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if (collectionView.cellForItem(at: indexPath) as? GridImageCell) != nil
        {
            if collectionView.indexPathsForSelectedItems?.count == 3
            {
                
            }
        }
        
        return true;
    }
    
    //Sets value to cells
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let c = collectionView.cellForItem(at: indexPath) as? GridImageCell
        {
            let touchedAt = c.touchTime!
            let response = responseId
            let test = testNumber
            let controller = self.controller
            let coll = collectionView
            let del = delegate
            let selection = controller.get(selectedData: indexPath.row, id: responseId, questionIndex: testNumber, gridType: .image)?.selection
            
           
            choiceIndicator?.removeFromSuperview()
            choiceIndicator?.targetView?.backgroundColor = UIColor(red: 191.0/255.0, green: 215.0/255.0, blue: 224.0/255.0, alpha: 1.0)
            choiceIndicator?.targetView?.layer.borderWidth = 1
            choiceIndicator?.targetView?.layer.borderColor = UIColor(red: 133.0/255.0, green: 141/255.0, blue: 145.0/255.0, alpha: 1.0).cgColor
            
            choiceIndicator = GridChoiceView(in: self.view, indexPath: indexPath, targetView: c, choice: selection) { popupSelection in
                
                switch popupSelection {
                case .set(let imageIndex, let index, let confirm_time):
                    let _ = controller.setValue(responseIndex: index.row,
                    responseData: imageIndex,
                    questionIndex: test,
                    gridType: .image,
                    time: touchedAt,
                    confirm_time: confirm_time,
                    id: response)
                case .unset(let index):
                    let _ = controller.unsetValue(responseIndex: index.row,
                               questionIndex: test,
                               gridType: .image,
                               id: response)
                }
                coll.reloadData()
                del?.didUpdateIndicator(indexPath: indexPath, indicator: nil)
                del?.didSelectGrid(indexPath: indexPath)
                c.isSelected = false
            }
            c.isSelected = true
            delegate?.didUpdateIndicator(indexPath: indexPath, indicator: choiceIndicator)
        }
        else if let c = collectionView.cellForItem(at: indexPath) as? GridFCell
        {
           // c.contentView.layer.backgroundColor = UIColor(red: 191.0/255.0, green: 215.0/255.0, blue: 224.0/255.0, alpha: 1.0).cgColor
            //c.backgroundColor = UIColor(red: 191.0/255.0, green: 215.0/255.0, blue: 224.0/255.0, alpha: 1.0) //UIColor(red: 182.0/255.0, green: 221.0/255.0, blue: 236.0/255.0, alpha: 1.0);
			//UIColor(red:0, green:0.37, blue:0.52, alpha:0.25)
            c.contentView.layer.backgroundColor = ACColor.primarySelected.cgColor
			c.label.textColor = ACColor.primary
			if c.label.text == "F" {
                _ = controller.update(fCountSteps: 1, testIndex: testNumber, id: responseId)
            } else if c.label.text == "E"{
                _ = controller.update(eCountSteps: 1, testIndex: testNumber, id: responseId)

            }
			//c.isSelected = true
			delegate?.didSelectLetter(indexPath: indexPath)
        }

    }
    ///- warning: Only unsets for e/f grid, image grid is now managed by GridChoiceIndicator
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        if let c = collectionView.cellForItem(at: indexPath) as? GridImageCell
        {
            //guard !isPracticeTest else { return }
            
            choiceIndicator?.removeFromSuperview()
            delegate?.didUpdateIndicator(indexPath: indexPath, indicator: nil)
            choiceIndicator?.targetView?.backgroundColor = UIColor(red: 191.0/255.0, green: 215.0/255.0, blue: 224.0/255.0, alpha: 1.0)
            choiceIndicator?.targetView?.layer.borderWidth = 1
            choiceIndicator?.targetView?.layer.borderColor = UIColor(red: 133.0/255.0, green: 141/255.0, blue: 145.0/255.0, alpha: 1.0).cgColor
//            delegate?.didUpdateIndicator(indexPath: indexPath, indicator: nil)
//            _ = controller.unsetValue(responseIndex: indexPath.row,
//            questionIndex: testNumber,
//            gridType: .image,
//            id: responseId)
//            self.currentHint?.removeFromSuperview()
//            self.currentHint = nil
//            delegate?.didUpdateIndicator(indexPath: indexPath, indicator: nil)
        }
        else if let c = collectionView.cellForItem(at: indexPath) as? GridFCell
        {
            c.contentView.layer.backgroundColor = UIColor.clear.cgColor
            c.label.textColor = ACColor.primary
            if c.label.text == "F" {
                _ = controller.update(fCountSteps: -1, testIndex: testNumber, id: responseId)
            } else if c.label.text == "E"{
                _ = controller.update(eCountSteps: -1, testIndex: testNumber, id: responseId)
                
            }
			//c.isSelected = false
			delegate?.didDeselectLetter(indexPath: indexPath)

        }
    }

	func overlayCell(at indexPath:IndexPath) -> UIView? {
		if mode == .image || mode == .answers {
			if let c = collectionView.cellForItem(at: indexPath) as? GridImageCell {
                view.overlayView(withShapes: [.roundedRect(c, 4, CGSize(width: 0, height: 0))])
				c.highlight()
                //c.image.isHidden = false
				return c
			}
		}
		if mode == .fCell {
			if let c = collectionView.cellForItem(at: indexPath) as? GridFCell {
                //c.overlay(radius: c.frame.width/2)
				view.overlayView(withShapes: [.roundedRect(c, c.frame.width/2, CGSize(width: -8, height: -8))])

                c.highlight(radius: c.frame.width/2)
				return c
			}
		}
		return nil
	}
	func overlayCells(at indexPaths:[IndexPath]) {
		
		let shapes = indexPaths.map {
            return OverlayShape.roundedRect(collectionView.cellForItem(at: $0)!, 4, CGSize(width: 0, height: 0))
		}
		view.overlayView(withShapes: shapes)
		for indexPath in indexPaths {
			if mode == .image || mode == .answers {
				if let c = collectionView.cellForItem(at: indexPath) as? GridImageCell {
					
					c.highlight(radius: 4.0)
					//c.image.isHidden = false
				}
			}
			if mode == .fCell {
				if let c = collectionView.cellForItem(at: indexPath) as? GridFCell {
					
					c.highlight(radius: c.frame.width/2)
					
				}
			}
		}
	}
    //MARK: Flow layout
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aspectRatio:CGFloat = 3/4
        if mode == .image || mode == .answers {
            var cellWidth = (UIScreen.main.bounds.size.width - 30)/5
            if SMALLER_GRIDS {
                cellWidth = (collectionViewWidth.constant)/5
            }
            //let cellWidth = (collectionViewWidth.constant)/5
            let cellHeight = cellWidth / aspectRatio
            return CGSize(width: cellWidth, height: cellHeight)
        } else if mode == .fCell {
            var cellWidth = (UIScreen.main.bounds.size.width - 44)/6
            if SMALLER_GRIDS {
                cellWidth = (collectionViewWidth.constant)/6
            }
            //let cellWidth = (collectionViewWidth.constant)/6
            let cellHeight = cellWidth
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            return CGSize(width: 1, height: 1)
        }
    }
    // Spacing between cell columns
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if mode == .image || mode == .answers {
            return (SMALLER_GRIDS ? 2 : 0)
        } else if mode == .fCell {
            return 2
        } else {
            return 0
        }
    }
    // Spacing between cell rows
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if mode == .image || mode == .answers {
            return 3
        } else if mode == .fCell {
            return 1
        } else {
            return 0
        }
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .image || mode == .answers {
            return UIEdgeInsets(top: 4, left:4, bottom: 4, right: 4)
            
        } else if mode == .fCell {
            return UIEdgeInsets(top: 8, left: 10, bottom: 4, right: 10)

            
        } else {
            return .zero
        }
    }
}
