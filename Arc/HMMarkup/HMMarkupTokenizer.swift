//
//  HMMarkupTokenizer.swift
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

private extension CharacterSet {
	static let delimiters = CharacterSet(charactersIn: "*~`^")
	static let whitespaceAndPunctuation = CharacterSet.whitespacesAndNewlines
		.union(CharacterSet.punctuationCharacters)
		.union(CharacterSet(charactersIn: "~"))
}

private extension UnicodeScalar {
	static let space: UnicodeScalar = " "
}

/**
Breaks a string into markup tokens.
How to use it:
var tokenizer = MarkupTokenizer(string: "_Hello *world*_")
while let token = tokenizer.nextToken() {
switch token {
case let .text(value):
print("text: \(value)"
case let .leftDelimiter(value):
print("left delimiter: \(value)"
case let .rightDelimiter(value):
print("right delimiter: \(value)"
}
}
*/
struct HMMarkupTokenizer {
	/// The input string
	private let input: String.UnicodeScalarView
	
	/// The index of the current character
	private var currentIndex: String.UnicodeScalarView.Index
	
	/// Keeps track of the left delimiters detected
	private var leftDelimiters: [UnicodeScalar] = []
	
	init(string: String) {
		input = string.unicodeScalars
		currentIndex = string.unicodeScalars.startIndex
	}
	
	mutating func nextToken() -> HMMarkupToken? {
		guard let c = current else {
			return nil
		}
		
		var token: HMMarkupToken?
		
		if CharacterSet.delimiters.contains(c) {
			token = scan(delimiter: c)
		} else {
			token = scanText()
		}
		
		if token == nil {
			token = .text(String(c))
			advance()
		}
		
		return token
	}
	
	private var current: UnicodeScalar? {
		guard currentIndex < input.endIndex else {
			return nil
		}
		
		return input[currentIndex]
	}
	
	private var previous: UnicodeScalar? {
		guard currentIndex > input.startIndex else {
			return nil
		}
		
		let index = input.index(before: currentIndex)
		return input[index]
	}
	
	private var next: UnicodeScalar? {
		guard currentIndex < input.endIndex else {
			return nil
		}
		
		let index = input.index(after: currentIndex)
		
		guard index < input.endIndex else {
			return nil
		}
		
		return input[index]
	}
	
	private mutating func scan(delimiter d: UnicodeScalar) -> HMMarkupToken? {
		return scanRight(delimiter: d) ?? scanLeft(delimiter: d)
	}
	
	private mutating func scanLeft(delimiter: UnicodeScalar) -> HMMarkupToken? {
		guard let n = next else {
			return nil
		}
		
        // Left delimiters must NOT be     followed by whitespaces or newlines
        guard !CharacterSet.whitespacesAndNewlines.contains(n) &&
			!leftDelimiters.contains(delimiter) else {
				return nil
		}
		
		leftDelimiters.append(delimiter)
		advance()
		
		return .leftDelimiter(delimiter)
	}
	
	private mutating func scanRight(delimiter: UnicodeScalar) -> HMMarkupToken? {
		guard let p = previous else {
			return nil
		}
		
        // Right delimiters must NOT be preceded by whitespace
		guard !CharacterSet.whitespacesAndNewlines.contains(p) &&
			leftDelimiters.contains(delimiter) else {
				return nil
		}
		
		while !leftDelimiters.isEmpty {
			if leftDelimiters.popLast() == delimiter {
				break
			}
		}
		advance()
		
		return .rightDelimiter(delimiter)
	}
	
	private mutating func scanText() -> HMMarkupToken? {
		let startIndex = currentIndex
		scanUntil { CharacterSet.delimiters.contains($0) }
		
		guard currentIndex > startIndex else {
			return nil
		}
		
		return .text(String(input[startIndex..<currentIndex]))
	}
	
	private mutating func scanUntil(_ predicate: (UnicodeScalar) -> Bool) {
		while currentIndex < input.endIndex && !predicate(input[currentIndex]) {
			advance()
		}
	}
	
	private mutating func advance() {
		currentIndex = input.index(after: currentIndex)
	}
}
