//
//  ACTodayProgressView.swift
//  Arc
//
//  Created by Philip Hayes on 8/1/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import Foundation
import ArcUIKit

public class ACTodayProgressView : UIView {
	private weak var backgroundImage:UIImageView!
	private var progressViews:[CircularProgressView] = []
	private weak var contentStack:UIStackView!
	private weak var titleLabel:ACLabel!
	private weak var sessionCompletionLabel:ACLabel!
	private weak var sessionRemainingLabel:ACLabel!
	private weak var badgeLabel:ACLabel!
	private var animations:[String:Animate] = [:]
	private weak var button:ACButton!
	public override init(frame: CGRect) {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = ACColor.primaryInfo

		backgroundImage = image {
			$0.image = UIImage(named: "finished_bg", in: Bundle(for: self.classForCoder), compatibleWith: nil)
			$0.contentMode = .scaleAspectFill
			
			$0.alpha = 0
			$0.layout {
				$0.top == topAnchor
				$0.trailing == trailingAnchor
				$0.bottom == bottomAnchor
				$0.leading == leadingAnchor
			}
		}
		
		
		contentStack = stack {[unowned self] in
			let stack = $0
			$0.layout {
				$0.centerX == centerXAnchor
				$0.centerY == centerYAnchor - 40
			}
			
			$0.axis = .vertical
			$0.alignment = .center
			self.titleLabel = $0.acLabel {
				stack.setCustomSpacing(34, after: $0)
				Roboto.Style.headingBold($0, color: ACColor.secondaryText)
				$0.text = "progress_schedule_header"
			}
			
			$0.stack {
				stack.setCustomSpacing(32, after: $0)

				for i in 1 ... 4 {
					let v = $0.circularProgress {
						$0.layout {
							$0.width == 64
							$0.height == 64
						}
						
						$0.config.strokeWidth = 6
						$0.config.barColor = ACColor.highlight
						$0.config.trackColor = ACColor.primary
						$0.checkConfig.scale = 0.5
						$0.progress = 0
					}
					progressViews.append(v)
				}
			}
			self.sessionCompletionLabel = $0.acLabel {
				stack.setCustomSpacing(22, after: $0)

				Roboto.Style.subHeading($0, color: ACColor.secondaryText)
				$0.text = "Test"
				
				
			}
			self.sessionRemainingLabel = $0.acLabel {
				stack.setCustomSpacing(22, after: $0)
				
				Roboto.Style.subHeading($0, color: ACColor.secondaryText)
				$0.text = "Test"
				
				
			}
			self.badgeLabel = $0.acLabel {

				$0.backgroundColor = ACColor.badgeBackground
				$0.layer.cornerRadius = 4
				$0.clipsToBounds = true
				Roboto.Style.badge($0)
				$0.text = "progress_schedule_status2"
			}
			
		}
		
		button = acButton {
			$0.layout {
				$0.bottom == safeAreaLayoutGuide.bottomAnchor
				$0.leading == safeAreaLayoutGuide.leadingAnchor + 32
				$0.trailing == safeAreaLayoutGuide.trailingAnchor - 32

			}
			
			$0.primaryColor = ACColor.secondary
			$0.secondaryColor = ACColor.secondaryText
			$0.setTitle("".localized(ACTranslationKey.button_next), for: .normal)
			$0.setTitleColor(ACColor.badgeText, for: .normal)
		}
		
		
		
		
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	public func set(sessionsCompleted:Int?, isPlural:Bool = false) {
		guard let sessionsCompleted = sessionsCompleted else {
			sessionCompletionLabel.isHidden = true
			return
		}
		sessionCompletionLabel.isHidden = false
		let key = (isPlural) ? ACTranslationKey.progress_schedule_body2 : ACTranslationKey.progress_schedule_body1
		sessionCompletionLabel.text = "".localized(key)
			.replacingOccurrences(of: "{#}", with: "\(sessionsCompleted)")
	}
	
	public func set(sessionsRemaining:Int?) {
		guard let sessionsRemaining = sessionsRemaining else {
			sessionRemainingLabel.isHidden = true
			return
		}
		sessionRemainingLabel.isHidden = false
		sessionRemainingLabel.text = "".localized(ACTranslationKey.progress_schedule_status1)
			.replacingOccurrences(of: "{#}", with: "\(sessionsRemaining)")
	}
	public func set(completed:Bool) {
		if completed {
			badgeLabel.isHidden = false
		} else {
			badgeLabel.isHidden = true
		}
	}
	
	public func set(progress:Double, for session:Int)  {
		let view = progressViews[session]

		if progress < 0 {
			UIView.animate(withDuration: 0.25) {
				//If we're hidden don't perform any animations
				view.isHidden = true
				self.layoutSubviews()
			}
			
			return
		} else {
			UIView.animate(withDuration: 0.25) {
				view.isHidden = false
				self.layoutSubviews()
			}
		}
		
		
		let oldVal = view.progress
		
		animations["\(session)"]?.stop()
		animations["\(session)"] = Animate()
			.delay(0.8 + 0.25 * Double(session + 1))
			.duration(0.25 * Double(session + 1))
			.curve(.easeOut)
			.run({ (time) -> Bool in
				
			view.progress = Math.lerp(a: oldVal, b: progress, t: time)
			
			return true
		})
	}
	
	
	private func fadeIn(view:UIView, delay:Double, duration:Double) {
		animations["bg"] = Animate().delay(0.2)
			.duration(0.8)
			.curve(.easeOut)
			.run({ [weak self](time) -> Bool in
				
				view.alpha = CGFloat(time)
				
				return true
			})
	}
	private func fadeInAndTranslate(view:UIView, translation:CGPoint, delay:Double, duration:Double) {
		let id = UUID().uuidString
		animations[id] = Animate().delay(delay)
			.duration(duration)
			.curve(.easeOut)
			.run({ [weak self] (time) -> Bool in
				
				let value = CGFloat(Math.lerp(a: 1.0, b: 0.0, t: time))
				
				view.alpha = CGFloat(time)
				view.transform = CGAffineTransform.identity.translatedBy(x: translation.x * value, y: translation.y * value)
				
				if time >= 1.0 {
					self?.animations.removeValue(forKey: id)
				}
				return true
			})
	}
}
