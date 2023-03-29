//
//  TestCountDownViewController.swift
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

public class TestCountDownViewController: CustomViewController<TestCountDownView> {
    public var nextVc:UIViewController?
    public var shouldProceedWhenActive = false
    public var isPaused = false
    
    var countdown: Int = 3
    
    init(nextVc:UIViewController) {
        self.nextVc = nextVc
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func viewDidLoad() {
        self.cancelButtonModalUseLightTint = false
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUiBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        debugPrint("Home Screen: Deint")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func refreshUiBecameActive() {
        // Fix for coming back into the count down view and it being stuck on 1
        if shouldProceedWhenActive {
            self.countdownComplete()
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.customView.countLabel.font = UIFont(name: "Georgia-Italic", size: 96)
        self.refreshCountdownText()
        self.countDown()
    }
    
    func countDown() {
        guard !self.isPaused else { return }
        DispatchQueue.main.asyncAfter(deadline: (.now() + 1.0), execute: {
            self.countdown -= 1
            if self.countdown == 0 {
                self.countdownComplete()
            } else {
                self.refreshCountdownText()
                self.countDown()
            }
        })
    }
    
    private func refreshCountdownText() {
        self.customView.countLabel.text = " \(countdown) "
    }
    
    private func countdownComplete() {
        if let arcVc = self.nextVc as? ArcViewController {
            arcVc.cancelButtomModal = self.cancelButtomModal
        }
        self.app.appNavigation.navigate(vc: self.nextVc!, direction: .toTop)
        self.shouldProceedWhenActive = true
    }
    
    open override func onOverlayResume() {
        super.onOverlayResume()
        self.isPaused = false
        self.countDown()
    }
    
    open override func showCancelOverlayView() {
        super.showCancelOverlayView()
        self.isPaused = true
    }
}
