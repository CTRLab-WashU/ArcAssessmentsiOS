//
//  ACHomeTabViewController.swift
//  ARC
//
//  Created by Philip Hayes on 8/6/19.
//  Copyright © 2019 healthyMedium. All rights reserved.
//

import UIKit

public extension Notification.Name {
	static let ACHomeStartOnboarding = Notification.Name(rawValue: "ACHomeStartOnboarding")
	
	//This will be used when the application triggers an earnings refresh
	//after finishing all uploads. 
	static let ACSessionUploadComplete = Notification.Name(rawValue: "ACSessionUploadComplete")
	static let ACSessionUploadFailure = Notification.Name(rawValue:"ACSessionUploadFailure")
	//This is to be used when the user manually refreshes the earnings call
	static let ACStartEarningsRefresh = Notification.Name("ACStartEarningsRefresh")
	static let ACEarningsUpdated = Notification.Name(rawValue: "ACEarningsUpdated")
	static let ACEarningDetailsUpdated = Notification.Name(rawValue: "ACEarningDetailsUpdated")
	static let ACStudySummaryUpdated = Notification.Name(rawValue: "ACStudySummaryUpdated")
}

public class ACHomeTabViewController: UITabBarController {
    
    public static var shouldShowEarningsTab = true

    open var buttonKeys: [ACTranslationKey] {
        var keys: [ACTranslationKey] = [.popup_next, .popup_next]
        if ACHomeTabViewController.shouldShowEarningsTab {
            keys.append(.popup_next)
        }
        keys.append(.popup_done)
        return keys
    }
    
    open var onboardingKeys: [ACTranslationKey] {
        var keys: [ACTranslationKey] = [.popup_tab_home, .popup_tab_progress]
        if ACHomeTabViewController.shouldShowEarningsTab {
            keys.append(.popup_tab_earnings)
        }
        keys.append(.popup_tab_resources)
        return keys
    }
    
    open var tabNames: [String] {
        var names = ["".localized(ACTranslationKey.resources_nav_home),
                     "".localized(ACTranslationKey.resources_nav_progress)]
        if ACHomeTabViewController.shouldShowEarningsTab {
            names.append("".localized(ACTranslationKey.resources_nav_earnings))
        }
        names.append("".localized(ACTranslationKey.resources_nav_resources))
        return names
    }

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
        self.tabNames
			.enumerated()
			.forEach {self.tabBar.items?[$0.offset].title = $0.element}
	}
    
    public override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		
		guard let items = self.tabBar.items else {
			assertionFailure("No items in tab bar")
			return
		}
		
        if item == items[0] {
            Arc.shared.activeTab = 0
            print("home")
        } else if item == items[1] {
            Arc.shared.activeTab = 1
            print("progress")
        }
        
        if ACHomeTabViewController.shouldShowEarningsTab {
            if item == items[2] {
                Arc.shared.activeTab = 2
                print("earnings")
            } else if item == items[3] {
                Arc.shared.activeTab = 3
                print("resources")
            }
        } else if item == items[2] {
            Arc.shared.activeTab = 2
            print("resources")
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = Arc.shared.activeTab
        // Do any additional setup after loading the view.
		
    }
    public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(displayOnboarding),
											   name: .ACHomeStartOnboarding,
											   object: nil)
	}
    public override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	@objc func displayOnboarding() {
		self.showTab(index: 0)
	}
	
	func showTab(index:Int) {
		
		
		var views:[UIControl] = tabBar.subviews.filter {$0 is UIControl} as! [UIControl]
		guard index < views.count else {
			view.window?.clearOverlay()
			view.isUserInteractionEnabled = true

			return
		}
		
		views.sort {$0.frame.minX < $1.frame.minX}
		let v = views[index]
		view.window?.overlayView(withShapes: [.circle(v)])
		view.isUserInteractionEnabled = false
		view.window?.hint {
			let hint = $0
			$0.layout {
				$0.centerX == v.centerXAnchor ~ 500
				$0.bottom == v.topAnchor - 20
				$0.leading >= view.leadingAnchor + 24
				$0.trailing <= view.trailingAnchor - 24
				$0.width == 232
			}
            $0.configure(with: IndicatorView.Config(primaryColor: UIColor(named:"HintFill")!,
                                                    secondaryColor: UIColor(named:"HintFill")!,
                                                    textColor: .black,
                                                    cornerRadius: 8.0,
                                                    arrowEnabled: true,
                                                    arrowAbove: false))
            $0.updateTitleStackMargins()
			$0.content = "".localized(self.onboardingKeys[index])
			$0.buttonTitle = "".localized(self.buttonKeys[index])
            $0.updateHintContainerMargins()
			$0.onTap = {[unowned self] in
				hint.removeFromSuperview()
				self.showTab(index: index + 1)
			}
			$0.targetView = v
		}
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
