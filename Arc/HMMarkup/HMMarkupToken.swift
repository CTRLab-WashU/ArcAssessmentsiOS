//
//  HMMarkupToken.swift
//  HMMarkup
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
enum HMMarkupToken {
	case text(String)
	case leftDelimiter(UnicodeScalar)
	case rightDelimiter(UnicodeScalar)
}

extension HMMarkupToken: Equatable {

}

extension HMMarkupToken: CustomStringConvertible {
	var description: String {
		switch self {
		case .text(let value):
			return value
		case .leftDelimiter(let value):
			return String(value)
		case .rightDelimiter(let value):
			return String(value)
		}
	}
}

extension HMMarkupToken: CustomDebugStringConvertible {
	var debugDescription: String {
		switch self {
		case .text(let value):
			return "text(\(value))"
		case .leftDelimiter(let value):
			return "leftDelimiter(\(value))"
		case .rightDelimiter(let value):
			return "rightDelimiter(\(value))"
		}
	}
}
