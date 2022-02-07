//
// ArcManager.swift
// Arc
//
//  Created by Philip Hayes on 9/26/18.
//  Copyright © 2018 healthyMedium. All rights reserved.
//

import Foundation
import UIKit
import PDFKit
public protocol ArcApi {
	
}
public extension Notification.Name {
	static let ACDateChangeNotification = Notification.Name(rawValue: "ACDateChangeNotification")
	
}

// Access this module's bundle from app context
public enum ArcBundle {
    public static let module = Bundle.module
}

public struct ArcAssessmentResult {
    public var signatures: [ArcAssessmentSignature]? = nil
    public var fullTestSession: FullTestSession? = nil
}

public protocol ArcAssessmentDelegate: AnyObject {
    func assessmentComplete(result: ArcAssessmentResult?)
}

public enum SurveyAvailabilityStatus: Equatable {
    case available, laterToday, tomorrow, startingTomorrow(String, String), laterThisCycle(String), later(String, String), finished, postBaseline
}
open class Arc : ArcApi {
    
	
	var ARC_VERSION_INFO_KEY = "CFBundleShortVersionString"
	var APP_VERSION_INFO_KEY = "CFBundleShortVersionString"
    
    public weak var delegate: ArcAssessmentDelegate? = nil    
    
	public var TEST_TIMEOUT:TimeInterval = 300; // 5 minute timeout if the application is closed
	public var TEST_START_ALLOWANCE:TimeInterval = -300; // 5 minute window before actual start time
    public var activeTab:Int = 0
	var STORE_DATA = false
	var FORGET_ON_RESTART = false
    
    lazy var arcInfo: NSDictionary? = {
        if let path = Bundle.module.path(forResource: "Info", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
            
        }
        return nil
    }()
    
	lazy var info: NSDictionary? = {
		if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
			return NSDictionary(contentsOfFile: path)
			
		}
		return nil
	}()
    
    lazy public var translation:ArcTranslation? = {
        do {
            guard let asset = Arc.shared.dataAsset(named: "translation") else {
                return nil
            }
            let translation:ArcTranslation = try JSONDecoder().decode(ArcTranslation.self, from: asset.data)
        
            return translation
        } catch {
            dump(error)
        }
        return nil
    }()
    
    public var translationIndex = 1
	lazy public var deviceString = {deviceInfo();}()
	lazy public var deviceId = AppController().deviceId
	lazy public var versionString = {info?[APP_VERSION_INFO_KEY] as? String ?? ""}()
	lazy public var arcVersion = {arcInfo?[ARC_VERSION_INFO_KEY] as? String ?? "";}()
    //A map of all of the possible states in the application
	
    // This controls the bundle that loads UIImages
    // To use your own custom images, override this to your app's bundle
    // And include the assets in your app's Assets with the same names as this library
    public var imageBundle = Bundle.module
    public func image(named: String) -> UIImage? {
        return UIImage(named: named, in: imageBundle, compatibleWith: nil)
    }
    public func image(named: String, in bundle: Bundle, compatibleWith: UITraitCollection?) -> UIImage? {
        return UIImage(named: named, in: bundle, compatibleWith: compatibleWith)
    }
    
    public var dataAssetBundle = Bundle.module
    public func dataAsset(named: String) -> NSDataAsset? {
        if let data = NSDataAsset(name: named, bundle: dataAssetBundle) {
            return data
        }
        return NSDataAsset(name: named)
    }
    
    static public let shared = Arc()
	
	public var appController:AppController = AppController()
	
	public var surveyController:SurveyController = SurveyController()
    
	public var gridTestController:GridTestController = GridTestController()
    
	public var pricesTestController:PricesTestController = PricesTestController()
    
	public var symbolsTestController:SymbolsTestController = SymbolsTestController()
	
	public var appNavigation:AppNavigationController = BaseAppNavigationController()
	
	public var controllerRegistry:ArcControllerRegistry = ArcControllerRegistry()
    
	//Back this value up with local storage.
	//When the app terminates this value is released,
	//This will cause background processes to crash when fired.
	public var participantId:Int? {
		get {
			return appController.participantId
		}
		set {
			appController.participantId = newValue
		}
	}
        
    public var availabilityStartHour: Int = 8 // 8 am
    public var availabilityEndHour: Int = 17 // 5 pm
    
	public var currentStudy:Int?
	public var availableTestSession:Int?
	public var currentTestSession:Int?
	static public var currentState:State?
    static public var environment:ArcEnvironment?
	static public var debuggableStates:[State] = []
	
	public init() {
		controllerRegistry.registerControllers()
	}
    static public func configureWithEnvironment(environment:ArcEnvironment) {
        
        FontLoader.configurePackageUI()
        
        self.environment = environment
        
        _ = MHController.dataContext
        
        Arc.shared.appNavigation = environment.appNavigation
        Arc.shared.appController = environment.appController
        
        Arc.shared.surveyController = environment.surveyController
        Arc.shared.gridTestController = environment.gridTestController
        Arc.shared.pricesTestController = environment.pricesTestController
        Arc.shared.symbolsTestController = environment.symbolsTestController
        
        let locale = Locale.current

        
        Arc.shared.setLocalization(country: Arc.shared.appController.country ?? locale.regionCode,
                                   language: Arc.shared.appController.language ?? locale.languageCode)

        environment.configure()
    }
    
    private func onTestComplete() {
        MHController.dataContext.performAndWait {
            guard let session = self.appController.getCurrentSessionResult() else {
                self.delegate?.assessmentComplete(result: nil)
                return
            }
            
            let signatures = self.appController.getCurrentSessionSignatures().map({ coreDataSignature in
                return ArcAssessmentSignature(data: coreDataSignature.data, tag: coreDataSignature.tag)
            })
            session.finishedSession = true
            let fullTestSession: FullTestSession = .init(withSession: session)
            let result = ArcAssessmentResult(signatures: signatures,
                                             fullTestSession: fullTestSession)

            DispatchQueue.main.async {
                self.delegate?.assessmentComplete(result: result)
            }
        }
    }
    
    public func nextAvailableState(direction:UIWindow.TransitionOptions.Direction = .toRight) {
		let statePossiblyNil = appNavigation.nextAvailableSurveyState()
        
        guard let state = statePossiblyNil else {
            self.onTestComplete()
            return
        }
        
        if !appNavigation.shouldNavigate(to: state) {
            print("App navigation blocked for state \(state)")
            return
        }
        
		ArcLog("Navigating to:  \(state)")        
		Arc.currentState = state
        appNavigation.navigate(state: state, direction: direction)
	}
    
	public func nextAvailableSurveyState() {
		
		let state = appNavigation.nextAvailableSurveyState() ?? appNavigation.defaultState()
		Arc.currentState = state
		appNavigation.navigate(state: state, direction: .toRight)
	}
	
	//A friend of a friend is a stranger.
	public static func store<T:Codable>(value:T?, forKey key:String) {
		Arc.shared.appController.store(value: value, forKey: key)

	}
	public static func delete(forKey key:String) {
		Arc.shared.appController.delete(forKey: key)

	}
	public static func read<T:Codable>(key:String) -> T? {
		return Arc.shared.appController.read(key: key)

	}

    ///Errors passed into this function will be uploaded using the crash reporter library. Choosing to raise
    ///the error will cause execution of the application to abort.
    ///Calling this function in try/catch handlers is recommended if you wish to log aberrant behavior
    ///or track when later maintenance changes the internal state of the application unexpectedly.
    /// - parameters:
    ///     - error: The error thrown.
    ///     - name: The name to give to the exception that will be uploaded.
    ///     - shouldRaise: a flag telling the application to end execution immediately.
    /// - attention: Choosing to raise an error will prevent the error from uploading immediately.
    /// it will, however, trigger the default crash reporter behavior and save the report. Then it will upload on
    /// next run of the application.
    /// - note: the should raise flag is especially useful for DEV and QA builds.
    /// - warning: Never raise during Production, fail safely and return the ui to a functional state.
    /// - version: 0.1
    public static func handleError(_ error:Error, named name:String, shouldRaise:Bool = false, userInfo:[AnyHashable:Any]? = nil) {
        let description = error.localizedDescription
        let exception = NSException(name: NSExceptionName(name),
                                    reason: description,
                                    userInfo: nil)
        handleException(exception)
    }
    public static func handleError(_ error:ErrorReport, named name:String, shouldRaise:Bool = false, userInfo:[AnyHashable:Any]? = nil) {
        let description = error.localizedDescription
        let exception = NSException(name: NSExceptionName(name),
                                    reason: description,
                                    userInfo: nil)
        handleException(exception)
    }
    private static func handleException(_ exception:NSException, raise:Bool = false) {
        if let log = LogManager.sharedInstance.getLog() {

        }
    }
    @discardableResult
    public func displayAlert(message:String, options:[MHAlertView.ButtonType], isScrolling:Bool = false) -> MHAlertView {
        let view:MHAlertView = (isScrolling) ? .get(nib: "MHScrollingAlertView") : .get()
        view.alpha = 0
        
        guard let window = UIApplication.shared.keyWindow else {
            return view
        }
        
        guard let _ = window.rootViewController else {
            
            return view
        }
        window.constrain(view: view)
        view.set(message: message, buttons: options)
        UIView.animate(withDuration: 0.35, delay: 0.1, options: .curveEaseOut, animations: {
            view.alpha = 1
        }) { (_) in
            
        }
		return view
    }
    public func setCountry(key:String?) {
        appController.country = key
    }
    public func setLanguage(key:String?) {
        appController.language = key
    }
	public func setLocalization(country:String?, language:String?, shouldTranslate:Bool = true) {

        let matchesBoth = Arc.shared.translation?.versions.filter {
            $0.map?["country_key"] == country && $0.map?["language_key"] == language
        }
        let matchesCountry = Arc.shared.translation?.versions.filter {
            $0.map?["country_key"] == country
        }
        let matchesLanguage = Arc.shared.translation?.versions.filter {
            $0.map?["language_key"] == language
        }
        
        var config = HMMarkupRenderer.Config()
        config.shouldTranslate = shouldTranslate

        config.translation =  matchesBoth?.first?.map ?? matchesLanguage?.first?.map ?? matchesCountry?.first?.map
        if shouldTranslate {
            print("Unable to load translation for \(country ?? "")_\(language ?? "")")
        }
        HMMarkupRenderer.config = config

    }
    public func setLocalization(index:Int = 1) {
       
            var config = HMMarkupRenderer.Config()
            config.shouldTranslate = true
            config.translation = Arc.shared.translation?.versions[index].map
            HMMarkupRenderer.config = config
      
    }
	public func deviceInfo() -> String
	{
		let deviceString = " \(UIDevice.current.systemName)|\(deviceIdentifier())|\(UIDevice.current.systemVersion)";
		return deviceString;
	}
    
   public static func getTopViewController<T:UIViewController>() -> T?{
	   guard let window = UIApplication.shared.keyWindow else {

		   return nil
	   }

	   guard let view = window.rootViewController else {
		   
		   return nil
	   }
	   if let nav = view as? UINavigationController {
		   return nav.topViewController as? T
	   }
	   if let tabs = view as? UITabBarController {
		   return tabs.selectedViewController as? T
	   }
	   return view as? T
   }
	
	public static func get(flag:ProgressFlag) -> Bool {
		return Arc.shared.appController.flags[flag.rawValue] ?? false
	}
	public static func set(flag:ProgressFlag) {
		Arc.shared.appController.flags[flag.rawValue] = true
	}
	public static func remove(flag:ProgressFlag) {
		Arc.shared.appController.flags[flag.rawValue] = false
	}
	
	public static func apply(forVersion version:String) {
		let components = version.components(separatedBy: ".")
		let major:Int = Int(components[0]) ?? 0
		let minor:Int = Int(components[1]) ?? 0
		let patch:Int = Int(components[2]) ?? 0
		for flag in ProgressFlag.prefilledFlagsFor(major: major, minor: minor, patch: patch) {
			set(flag: flag)
		}
	}
	
	public static  func screenShot(state:State) -> [UIImage]? {
		let vc = state.viewForState()
		var images = [UIImage]()
		print("Snapshotting \(state)")
		if let v = vc as? BasicSurveyViewController {
			v.autoAdvancePageIndex = false
			for question in (v.questions + (v.subQuestions ?? [])).enumerated() {
				
				
				//This controller uses internal indexing, a side effect is triggered by addController
				
				v.addController(v.customViewController(forQuestion: question.element))
				v.currentIndex = question.offset
				v.display(question: question.element)
				guard let image = imageFromView(view: v.view) else {
					continue
				}
				images.append(image)
			}
			return images
		}
		if 	let v = vc as? CustomViewController<ACTemplateView>,
			let image = imageFromView(view: v.customView.root.subviews[0]) {
			return [image]
		}
		return nil

	}
	public static  func screenShot(viewController:UIViewController) -> UIView? {
		
		return viewController.view
	}
	public static  func imageFromView(view:UIView) -> UIImage? {
		let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
		print("Drawing image")
		let image = renderer.image { ctx in
			view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
		}
		
		return image
	}
	public static  func save(image:UIImage, withName name:String) -> URL? {
		if let data = image.pngData() {
			let filename = getCachesDirectory().appendingPathComponent(name)
			try? data.write(to: filename)
			return filename
		}
		return nil
	}
	
	public static func createPDFDataFromImage(images: [UIImage]) -> URL? {
		let pdfData = NSMutableData()
		guard let window = UIApplication.shared.keyWindow else {
			assertionFailure("No Keywindow")
			
			return nil
		}
		let imageRect = CGRect(x: 0, y: 0, width: window.frame.width + 200, height: window.frame.height + 200)
		UIGraphicsBeginPDFContextToData(pdfData, imageRect, nil)
		for image in images {
			UIGraphicsBeginPDFPage()
			let context = UIGraphicsGetCurrentContext()
			context?.setFillColor(UIColor.black.cgColor)
			context?.fill(imageRect)
			
			image.draw(in: CGRect(x: 100, y: 50, width: image.size.width, height: image.size.height))
		}
		UIGraphicsEndPDFContext()

		//try saving in doc dir to confirm:
		let dir = getCachesDirectory()
		let path = dir.appendingPathComponent("ScreenShots.pdf")

		do {
				try pdfData.write(to: path, options: NSData.WritingOptions.atomic)
		} catch {
			print("error catched")
		}

		return path
	}
	public static func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	public static func getCachesDirectory() -> URL {
		let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
		return paths[0]
	}
}

