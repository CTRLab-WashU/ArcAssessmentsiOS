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

public class CancelButtonModal {
    public var overlayView: UIView? = nil
    public var cancelButtonImage: UIImage? = nil
    public var shouldShowModal = true
    public var darkTintColor = UIColor.white
    public var lightTintColor = UIColor.white
    
    public static func createPauseButtonModal() -> CancelButtonModal {
        let modal = CancelButtonModal()
        modal.cancelButtonImage = UIImage(named: "pause", in: Bundle.module, with: nil)
        modal.shouldShowModal = true
        modal.lightTintColor = UIColor.white
        modal.darkTintColor = ACColor.primary
        return modal
    }
    
    public static func createExitButtonModal() -> CancelButtonModal {
        let modal = CancelButtonModal()
        modal.cancelButtonImage = UIImage(named: "exit", in: Bundle.module, with: nil)
        modal.shouldShowModal = false
        modal.lightTintColor = UIColor.white
        modal.darkTintColor = ACColor.primary
        return modal
    }
}

open class ArcViewController: UIViewController {
	public var app:Arc {
		get {
			return Arc.shared
		}
		set {
			
		}
	}
    
    public var cancelButtomModal: CancelButtonModal? = nil
    public var cancelButtonModalUseLightTint = true
    private let cancelButtonModalAnimTime = 0.25
    
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
        self.createCancelButtonModalIfNecessary()
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
    
    func createCancelButtonModalIfNecessary() {
        guard let modal = self.cancelButtomModal,
              let cancelButtonImage = modal.cancelButtonImage else {
            return
        }
        
        let cancelButton = UIButton(type: .custom)
        if self.cancelButtonModalUseLightTint {
            cancelButton.tintColor = modal.lightTintColor
        } else {
            cancelButton.tintColor = modal.darkTintColor
        }
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(cancelButtonImage, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelModalButtonPressed), for: .touchUpInside)
        self.view.add(cancelButton)
        // Add constraints to position the view in the top right corner
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(16)),
            cancelButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: CGFloat(-4))
        ])
    }
	
    open func showCancelOverlayView() {
        guard let modal = self.cancelButtomModal else { return }
        
        let overlayColor = UIColor(red: 87/255, green: 94/255, blue: 113/255, alpha: 0.96)
        let primaryButtonTitleColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        
        let titleFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
        let titleColor = UIColor.white
        let titleTopSpacing = CGFloat(44)
        
        let dividerLineSize = CGFloat(2)
        let dividerLineTopSpacing = CGFloat(22)
        
        let buttonHeight = CGFloat(56)
        let buttonFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let buttonBorderWidth = CGFloat(2)
        
        let vStackSpacing = CGFloat(16)
        let vStackChildHSpacing = CGFloat(32)
        
        modal.overlayView = UIView()
        let overlayView = modal.overlayView!
        overlayView.backgroundColor = overlayColor
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        self.view.add(overlayView)
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: self.view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        let title = UILabel()
        title.text = "Paused"
        title.textAlignment = .center
        title.textColor = titleColor
        title.font = titleFont
        title.translatesAutoresizingMaskIntoConstraints = false
        overlayView.add(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: titleTopSpacing),
            title.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
        ])
        
        let divider = UIView()
        divider.backgroundColor = UIColor.white
        divider.translatesAutoresizingMaskIntoConstraints = false
        overlayView.add(divider)
        divider.heightAnchor.constraint(equalToConstant: dividerLineSize).isActive = true
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: title.bottomAnchor, constant: dividerLineTopSpacing),
            divider.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
        ])
        
        let buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(buttonView)
        NSLayoutConstraint.activate([
            buttonView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            buttonView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            buttonView.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor)
        ])
        
        let resume = UIButton(type: .system)
        resume.setTitle("Resume", for: .normal)
        resume.setTitleColor(primaryButtonTitleColor, for: .normal)
        resume.titleLabel?.font = buttonFont
        resume.backgroundColor = UIColor.white
        resume.addTarget(self, action: #selector(overlayResumePressed), for: .touchUpInside)
        resume.translatesAutoresizingMaskIntoConstraints = false
        resume.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        resume.layer.cornerRadius = buttonHeight / CGFloat(2)
                        
        let skip = UIButton(type: .system)
        skip.setTitle("Skip this activity", for: .normal)
        skip.setTitleColor(.white, for: .normal)
        skip.titleLabel?.font = buttonFont
        skip.layer.borderWidth = buttonBorderWidth
        skip.layer.borderColor = UIColor.white.cgColor
        skip.backgroundColor = .clear
        skip.addTarget(self, action: #selector(overlaySkipPressed), for: .touchUpInside)
        skip.translatesAutoresizingMaskIntoConstraints = false
        skip.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        skip.layer.cornerRadius = buttonHeight / CGFloat(2)
        
        let continueLater = UIButton(type: .system)
        continueLater.setTitle("Continue Later", for: .normal)
        continueLater.setTitleColor(.white, for: .normal)
        continueLater.titleLabel?.font = buttonFont
        continueLater.layer.borderWidth = buttonBorderWidth
        continueLater.layer.borderColor = UIColor.white.cgColor
        continueLater.backgroundColor = .clear
        continueLater.addTarget(self, action: #selector(overlayContinueLaterPressed), for: .touchUpInside)
        continueLater.translatesAutoresizingMaskIntoConstraints = false
        continueLater.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        continueLater.layer.cornerRadius = buttonHeight / CGFloat(2)
        
        let vStack = UIStackView(arrangedSubviews: [resume, skip, continueLater])
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fillEqually
        vStack.spacing = vStackSpacing
        vStack.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: vStackChildHSpacing),
            vStack.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -vStackChildHSpacing),
            vStack.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor)
        ])
        
        overlayView.alpha = 0.0
        UIView.animate(withDuration: cancelButtonModalAnimTime) {
            overlayView.alpha = 1.0
        }
    }
    
    private func hideModal() {
        self.cancelButtomModal?.overlayView?.alpha = 1.0
        UIView.animate(withDuration: cancelButtonModalAnimTime, animations: {
            self.cancelButtomModal?.overlayView?.alpha = 0.0
        }) { _ in
            self.cancelButtomModal?.overlayView?.removeFromSuperview()
            self.cancelButtomModal?.overlayView = nil
        }
    }
    
    open func onOverlayResume() {
        // can be implemented by subclass to pause the UX
    }
    
    @objc func overlayResumePressed() {
        self.hideModal()
        self.onOverlayResume()
    }
    
    @objc func overlaySkipPressed() {
        self.hideModal()
        Arc.shared.navigationDelegate?.onAssessmentSkipRequested()
    }
    
    @objc func overlayContinueLaterPressed() {
        self.hideModal()
        Arc.shared.navigationDelegate?.onAssessmentCancelRequested()
    }

    @objc func cancelModalButtonPressed() {
        if self.cancelButtomModal?.shouldShowModal == false {
            Arc.shared.navigationDelegate?.onAssessmentCancelRequested()
        } else {
            self.showCancelOverlayView()
        }
    }
}
