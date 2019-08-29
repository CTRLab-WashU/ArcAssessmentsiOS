//
//  ProgressFlag.swift
//  Arc
//
//  Created by Philip Hayes on 8/6/19.
//  Copyright © 2019 HealthyMedium. All rights reserved.
//

import Foundation

public enum ProgressFlag : String {
	//0.1.0
	case tutorial_complete
	case tutorial_grats
	case first_test_begin
	case baseline_completed
	case baseline_onboarding
	case baseline_onboarding_home
	case baseline_onboarding_progress
	case baseline_onboarding_earnings
	case baseline_onboarding_resources
    case grids_tutorial_shown
    case symbols_tutorial_shown
    case prices_tutorial_shown
	
	//For every version add a new case that runs for that version specifically.
	static public func prefilledFlagsFor(major:Int, minor:Int, patch:Int) -> Set<ProgressFlag> {
		switch (major, minor, patch) {
		case let (major, _, _) where major >= 0:
			return [.tutorial_grats, .tutorial_complete, .first_test_begin, .baseline_completed, .baseline_onboarding, .baseline_onboarding_earnings, .baseline_onboarding_home, .baseline_onboarding_progress, .baseline_onboarding_resources]
			
		default:
			break
		}
		return []
		
	}
}