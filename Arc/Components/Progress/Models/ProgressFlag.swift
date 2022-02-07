//
//  ProgressFlag.swift
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

import Foundation

public enum ProgressFlag : String {
	//0.1.0
	case tutorial_complete
	case tutorial_grats
	case first_test_begin
	case baseline_completed
	case baseline_onboarding

    case paid_test_completed
    case grids_tutorial_shown
    case symbols_tutorial_shown
    case prices_tutorial_shown
	case tutorial_optional

    case time_picker_hint_shown
    case slider_hint_shown
    
	//For every version add a new case that runs for that version specifically.
	static public func prefilledFlagsFor(major:Int, minor:Int, patch:Int) -> Set<ProgressFlag> {
		var flags:Set<ProgressFlag> = []
		switch (major, minor, patch) {
		case let (major, _, _) where major < 2: 
			flags = flags.union([.tutorial_grats, .tutorial_complete, .first_test_begin, .baseline_completed, .paid_test_completed, .tutorial_optional])
	
		case let (major, _, _) where major >= 2:
			flags = flags.union([.tutorial_grats, .tutorial_complete, .first_test_begin, .baseline_completed, .baseline_onboarding, .paid_test_completed, .tutorial_optional, .grids_tutorial_shown, .symbols_tutorial_shown, .prices_tutorial_shown])
			
		default:
			break
		}
		return flags
		
	}
}
