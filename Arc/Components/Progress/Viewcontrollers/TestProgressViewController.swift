//
//  TestProgressViewController.swift
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

public protocol TestProgressViewControllerDelegate : class {
	func testProgressDidComplete()
}
public class TestProgressViewController: CustomViewController<TestProgressView> {
	public weak var delegate:TestProgressViewControllerDelegate?
	private var timer:Timer?
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
	init(title:String, subTitle:String, count:Int, maxCount:Int = 3) {
		
		super.init()
		
		customView.title = title
		customView.subTitle = subTitle
		customView.count = count
		customView.maxCount = maxCount
		customView.dividerWidth = 1.0
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
	
    }
    
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		customView.dividerWidth = 1.0
		
		
	}
	public func set(count:Int) {
		customView.count = count
	}
	public func set(maxCount:Int) {
		customView.maxCount = maxCount
	}
	public func waitAndExit(time:TimeInterval) {
		timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: {[weak self] (timer) in
			self?.delegate?.testProgressDidComplete()
			
		})
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
