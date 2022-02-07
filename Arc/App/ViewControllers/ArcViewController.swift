//
//  MHViewController.swift
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



open class ArcViewController: UIViewController {
	public var app:Arc {
		get {
			return Arc.shared
		}
		set {
			
		}
	}
	public var currentHint:HintView?
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	public init() {
		super.init(nibName: nil, bundle: nil)
		modalPresentationStyle = .fullScreen

	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		modalPresentationStyle = .fullScreen

	}
    override open func viewDidLoad() {
        super.viewDidLoad()
		

        // Do any additional setup after loading the view.
    }
	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	open override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}
	open func apply(forVersion version:String) {
		let major:Int = Int(version.components(separatedBy: ".")[0]) ?? 0
		let minor:Int = Int(version.components(separatedBy: ".")[1]) ?? 0
		let patch:Int = Int(version.components(separatedBy: ".")[2]) ?? 0
		for flag in ProgressFlag.prefilledFlagsFor(major: major, minor: minor, patch: patch) {
			set(flag: flag)
		}
	}
	open func get(flag:ProgressFlag) -> Bool {
		return app.appController.flags[flag.rawValue] ?? false
	}
	open func set(flag:ProgressFlag) {
		app.appController.flags[flag.rawValue] = true
	}
	open func remove(flag:ProgressFlag) {
		app.appController.flags[flag.rawValue] = false
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
