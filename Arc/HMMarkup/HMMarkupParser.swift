//
//  HMMarkupParser.swift
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
public struct HMMarkupParser {
	public static func parse(text: String) -> [HMMarkupNode] {
		var parser = HMMarkupParser(text: text)
		return parser.parse()
	}
	
	private var tokenizer: HMMarkupTokenizer
	private var openingDelimiters: [UnicodeScalar] = []
	
	private init(text: String) {
		tokenizer = HMMarkupTokenizer(string: text)
	}
	
	private mutating func parse() -> [HMMarkupNode] {
		var elements: [HMMarkupNode] = []
		
		while let token = tokenizer.nextToken() {
			switch token {
			case .text(let text):
				elements.append(.text(text))
				
			case .leftDelimiter(let delimiter):
				// Recursively parse all the tokens following the delimiter
				openingDelimiters.append(delimiter)
				elements.append(contentsOf: parse())
				
			case .rightDelimiter(let delimiter) where openingDelimiters.contains(delimiter):
				guard let containerNode = close(delimiter: delimiter, elements: elements) else {
					fatalError("There is no MarkupNode for \(delimiter)")
				}
				return [containerNode]
				
			default:
				elements.append(.text(token.description))
			}
		}
		
		// Convert orphaned opening delimiters to plain text
		let textElements: [HMMarkupNode] = openingDelimiters.map { .text(String($0)) }
		elements.insert(contentsOf: textElements, at: 0)
		openingDelimiters.removeAll()
		
		return elements
	}
	
	private mutating func close(delimiter: UnicodeScalar, elements: [HMMarkupNode]) -> HMMarkupNode? {
		var newElements = elements
		
		// Convert orphaned opening delimiters to plain text
		while openingDelimiters.count > 0 {
			let openingDelimiter = openingDelimiters.popLast()!
			
			if openingDelimiter == delimiter {
				break
			} else {
				newElements.insert(.text(String(openingDelimiter)), at: 0)
			}
		}
		
		return HMMarkupNode(delimiter: delimiter, children: newElements)
	}
}
