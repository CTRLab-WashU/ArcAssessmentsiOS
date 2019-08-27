//
//  TutorialView.swift
//  Arc
//
//  Created by Philip Hayes on 7/3/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import UIKit
import ArcUIKit
class TutorialView: UIStackView {
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
	init() {
		
		super.init(frame: .zero)
		axis = .vertical
		header()
		container()
	}
	public func header() {
		headerView = view { [weak self] in
			$0.backgroundColor = UIColor(named:"Primary Info")
			self?.headerStack = $0.stack {
				$0.axis = .horizontal
				$0.spacing = 8
				
				$0.alignment = .center
				$0.isLayoutMarginsRelativeArrangement = true
				$0.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 20)
				self?.closeButton = $0.button {
					$0.setImage(UIImage(named:"cut-ups/icons/X-to-close"), for: .normal)
					$0.imageView?.contentMode = .scaleAspectFit
					$0.tintColor = UIColor(named:"Highlight")
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
			$0.backgroundColor = .white
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
        self.closeButton.isHidden = true
        self.headerStack.layoutMargins = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    }
	
}
