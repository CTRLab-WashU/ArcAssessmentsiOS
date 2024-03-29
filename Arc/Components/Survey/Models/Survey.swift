//
//  Survey.swift
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
/*
 The JSON format that the app will use to read in all surveys
 */
import Foundation



public struct Survey : ArcCodable {
    
	public static var dataType: SurveyType = SurveyType.unknown

	
    public struct Question : Codable {
		
		public struct Answer : QuestionResponse {
			public var text_value: String?
			
			public var type: QuestionType? = .none
			
            public var answerId:String
            public var value:Any?
			public var exclusive:Bool?
			
			private enum CodingKeys : CodingKey {
				case answerId, value, exclusive
			}
			
		}
        
        public struct Route : Codable {
            public var answerId:String?; //Look for this answer
            public var operand:String?; //If the value == another value <,>,<=, >=
            public var value:Any?; //Value to compare
            public var nextQuestionId:String //Pull a question from the subquestions
			
			private enum CodingKeys : CodingKey {
				case answerId, value, operand, nextQuestionId
			}
        }
        
        public var type:QuestionType?
        public var style: QuestionStyle?
		public var state:String?
        public var questionId:String
        public var prompt:String
		public var subTitle:String?
		public var title:String?
        public var detail:String?
        public var content:String?
        public var minMessage:String?
        public var maxMessage:String?
        public var minValue:Float?
        public var maxValue:Float?
        public var value:String?
        public var answers:Array<Answer>? // if a question has predefined answers
        public var routes:Array<Route>?
		public var nextButtonTitle:String?
        public var nextButtonImage:String?
        public var altNextButtonTitle:String?
        public var altNextButtonImage:String?
        public var backgroundStyle:String?

    }
    public struct Instruction : Codable {
        public var title : String
        public var subtitle : String
        public var preface : String
		public var nextButtonTitle:String?
        public var nextButtonImage:String?

        public var backgroundStyle:String?
    }
    public var id:String?
    public var type: SurveyType?
    public var instructions:Array<Instruction>?
	public var postSurvey:Array<Instruction>?
    public var questions:Array<Question>
    public var subQuestions:Array<Question>?

}


extension Survey.Question.Route {
    public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.answerId = try container.decodeIfPresent(String.self, forKey: .answerId)
		self.operand = try container.decodeIfPresent(String.self, forKey: .operand)
		self.nextQuestionId = try container.decode(String.self, forKey: .nextQuestionId)

		//Decoding Any from type
		do {
			self.value = try container.decodeIfPresent(String.self, forKey: .value)
		} catch {
			do {
				self.value = try container.decodeIfPresent(Int.self, forKey: .value)
			} catch {
				do {
					self.value = try container.decodeIfPresent([Int].self, forKey: .value)
				} catch {
					fatalError("Invalid type specified for Value: \(error.localizedDescription)")
				}
			}
		}
		
		
	}
    public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(answerId, forKey: .answerId)
		try container.encode(operand, forKey: .operand)
		try container.encode(nextQuestionId, forKey: .nextQuestionId)

		
		//Encoding Any to various types
		switch value {
		case let v as String:
			try container.encodeIfPresent(v, forKey: .value)

			
		case let v as Int:
			try container.encodeIfPresent(v, forKey: .value)

			
		case let v as [Int]:
			try container.encodeIfPresent(v, forKey: .value)

		case .none:
			break
		case .some(_):
			break
		}
		
		
	}
}

extension Survey.Question.Answer {
    public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.answerId = try container.decode(String.self, forKey: .answerId)
		self.exclusive = try container.decodeIfPresent(Bool.self, forKey: .exclusive)
		
		//Decoding Any from type
		do {
			self.value = try container.decodeIfPresent(String.self, forKey: .value)
		} catch {
			do {
			self.value = try container.decodeIfPresent(Int.self, forKey: .value)
			} catch {
				do {
				self.value = try container.decodeIfPresent([Int].self, forKey: .value)
				} catch {
					fatalError("Invalid type specified for Value: \(error.localizedDescription)")
				}
			}
		}
		
		
		
			
		
		
		
		
		
	}
    public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(answerId, forKey: .answerId)
		try container.encodeIfPresent(exclusive, forKey: .exclusive)
		
		
		//Encoding Any to various types
		if let type = type {
			switch type {
			case .none, .text, .time, .duration, .password, .segmentedText, .multilineText, .number:
				let v:String = self.value as! String
				try container.encodeIfPresent(v, forKey: .value)
				
			case .slider:
				let v:Float = self.value as! Float
				try container.encodeIfPresent(v, forKey: .value)

			case .choice, .picker:
				let v:Int = self.value as! Int
				try container.encodeIfPresent(v, forKey: .value)
				
				
			case .checkbox:
				let v:[Int] = self.value as! [Int]
				try container.encodeIfPresent(v, forKey: .value)
				
            case .image, .calendar, .signature:
                break
            
            }
		}
		
	}
}
