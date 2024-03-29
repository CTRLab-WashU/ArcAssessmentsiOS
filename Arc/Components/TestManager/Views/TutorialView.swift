//
//  TutorialView.swift
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

public class TutorialView: UIStackView {
	var headerView:UIView!
    var headerStack:UIStackView!
	var progressBar:ACHorizontalBar!
	var containerView:UIView!
	var contentView:UIViewController?
	var closeButton:UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	public init() {
		
		super.init(frame: .zero)
		axis = .vertical
		header()
		container()
	}
	public func header() {
		headerView = view { [weak self] in
			$0.backgroundColor = ACColor.primaryInfo
			self?.headerStack = $0.stack {
				$0.axis = .horizontal
				$0.spacing = 8
				
				$0.alignment = .center
				$0.isLayoutMarginsRelativeArrangement = true
				$0.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 20)
				self?.closeButton = $0.button {
					$0.setImage(Arc.shared.image(named:"cut-ups/icons/X-to-close"), for: .normal)
					$0.imageView?.contentMode = .scaleAspectFit
                    $0.tintColor = ACColor.highlight
					$0.layout {
						$0.height == 30
					}
				}
                $0.stack {
                    $0.axis = .horizontal
                    $0.alignment = .center
                    $0.layout {
                        $0.height == 30
                    }
                    $0.acHorizontalBar {
                        $0.relativeWidth = 0
                        $0.clipsToBounds = false
                        $0.backgroundColor = .white
                        $0.layout {
                            $0.height == 2 ~ 999
                        }
                        let v = $0
                        self?.progressBar = $0.acHorizontalBar {
							$0.animation = $0.animation.curve(.easeOut).delay(0.2)

                            $0.relativeWidth = 0.05
                            $0.cornerRadius = 8.0
                            $0.backgroundColor = .clear
                            $0.layout {
                                $0.height == 8
                                $0.width == v.widthAnchor
                                $0.leading == v.leadingAnchor
                                $0.top == v.topAnchor - 3
                            }
                            
                        }
                    }
                }

                let v = $0
				$0.layout {
				
					$0.top == v.superview!.topAnchor ~ 999
					$0.trailing == v.superview!.trailingAnchor ~ 999
					$0.bottom == v.superview!.bottomAnchor ~ 999
					$0.leading == v.superview!.leadingAnchor ~ 999
				}
			}
		}
		headerView.layout { [weak self] in
			
			$0.top == self!.safeAreaLayoutGuide.topAnchor ~ 999

			$0.width == self!.widthAnchor ~ 999
			
			
		}
	}
	public func container() {
		containerView = view {
			$0.backgroundColor = .black
		}
		containerView.layout { [weak self] in
			$0.width == self!.widthAnchor ~ 999
		}
	}
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	public func setContent(viewController:UIViewController) {
		
		if let c = contentView {
			c.removeFromParent()
			c.view.removeFromSuperview()
		}
		contentView = viewController
		viewController.view.translatesAutoresizingMaskIntoConstraints = false
		containerView.anchor(view:viewController.view)
		
	}
    
    public func firstTutorialRun() {
		
		guard !Arc.get(flag: .tutorial_optional) else {
			
			//If these flags are set then we don't have to hide the xbutton for the first test run. 
			return
		}
        self.closeButton.isHidden = true
		
        self.headerStack.layoutMargins = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    }
	
}
