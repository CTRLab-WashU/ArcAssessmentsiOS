//
//  File.swift
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

import Foundation
public struct AnyTest : Codable {
	public var data:ArcCodable
	
	public init (_ data:ArcCodable) {
		self.data = data
	}
	private enum CodingKeys : CodingKey {
		case type, data
	}
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let type = try container.decode(SurveyType.self, forKey: .type)
		self.data = try type.metatype.init(from: decoder)
	}
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(type(of: data).dataType, forKey: .type)
		try data.encode(to: encoder)
		
	}
}
public struct CognitiveTest : ArcCodable {
	
	
	public static var dataType: SurveyType = .cognitive
	
	public var id:String?
	public var type:SurveyType? = .cognitive
	public var context_survey:SurveyResponse?
	public var wake_survey:SurveyResponse?
	public var chronotype_survey:SurveyResponse?
	public var grid_test:GridTestResponse?
	public var price_test:PriceTestResponse?
	public var symbol_test:SymbolsTestResponse?
	public init() {
		
	}
}
public struct FullTestSession : Codable {
	public var id:String?
	public var week:Int64?
	public var	day:Int64?
	public var session:Int64?
	public var	session_id:String? //"[some unique identifier that will always identify this session]",
	public var	session_date:TimeInterval? //1503937447.437798,
	public var start_time:TimeInterval? // 1503937447.732328,
	public var participant_id:String? //"111111",
	public var interrupted:Int64?// 0,
	public var missed_session:Int64? // 0,
	public var finished_session:Int64? // 1,
	public var device_id:String? // "[device id]",
	public var device_info:String? // "iOS|iPhone8,4|10.1.1",
	public var app_version:String? // "1.2.4",
	public var model_version:String? // "1",
	
	
	public var tests: [AnyTest]

	
	
	public init(withSession session: Session) {
		
		
		week = session.week
		day = session.day
		self.session = session.session
		session_id = "\(session.sessionID)"
		session_date = session.sessionDate?.timeIntervalSince1970
		start_time = session.startTime?.timeIntervalSince1970
        if let pId = Arc.shared.participantId {
            participant_id = "\(pId)"
        } else {
            participant_id = ""
        }
		if let interrupted = session.interrupted {
			self.interrupted = interrupted as? Int64

		}
		missed_session = (session.missedSession) ? 1 : 0
		finished_session = (session.finishedSession) ? 1 : 0
		
		device_id = Arc.shared.deviceId
		device_info = Arc.shared.deviceInfo()
		app_version = Arc.shared.versionString
		model_version = "\(Arc.shared.arcVersion)"
		
		//All sessions have been prefilled with json data at the begining of the study
		tests = []
	
		
		if var survey:SurveyResponse = session.getSurveyFor(surveyType: .ema)?.get() {
			survey.id = nil
			tests.append(AnyTest(survey))
		}
		if var survey:SurveyResponse = session.getSurveyFor(surveyType: .edna)?.get() {
			survey.id = nil
			tests.append(AnyTest(survey))
		}
		if var survey:SurveyResponse = session.getSurveyFor(surveyType: .mindfulness)?.get() {
			survey.id = nil
			tests.append(AnyTest(survey))
		}

		
		
		var cognitive:CognitiveTest = CognitiveTest()
		
		if var survey:SurveyResponse = session.getSurveyFor(surveyType: .context)?.get() {
			survey.id = nil
			cognitive.context_survey = survey
			cognitive.id = survey.id
		}
		
		if var survey:SurveyResponse = session.getSurveyFor(surveyType: .chronotype)?.get() {
			survey.id = nil

			cognitive.chronotype_survey = survey
		}
		if var survey:SurveyResponse = session.getSurveyFor(surveyType: .wake)?.get() {
			survey.id = nil

			cognitive.wake_survey = survey
		}
		
		if var survey:GridTestResponse = session.getSurveyFor(surveyType: .gridTest)?.get() {
			survey.id = nil

			cognitive.grid_test = survey
		}
		if var survey:PriceTestResponse = session.getSurveyFor(surveyType: .priceTest)?.get() {
			survey.id = nil

			cognitive.price_test = survey
		}
		if var survey:SymbolsTestResponse = session.getSurveyFor(surveyType: .symbolsTest)?.get() {
			survey.id = nil

			cognitive.symbol_test = survey

		}
		if cognitive.context_survey != nil ||
            cognitive.wake_survey != nil ||
            cognitive.chronotype_survey != nil ||
            cognitive.price_test != nil ||
            cognitive.grid_test != nil ||
            cognitive.symbol_test != nil {
			tests.append(AnyTest(cognitive))
		}
		
		
		id = "\(session.sessionID)"
		
	}
}

public struct CognitiveTestSession : Codable {
	var id:String
	var week:Int64?
	var	day:Int64?
	var session:Int64?
	var	session_id:String? //"[some unique identifier that will always identify this session]",
	var	sessionDate:TimeInterval? //1503937447.437798,
	var startTime:TimeInterval? // 1503937447.732328,
	var participant_id:String? //"111111",
	
	var missedSession:Int64? // 0,
	var finishedSession:Int64? // 1,
	var device_id:String? // "[device id]",
	var device_info:String? // "iOS|iPhone8,4|10.1.1",
	var app_version:String? // "1.2.4",
	var model_version:String? // "1",
	
	var contextSurvey: SurveyResponse
	var gridTest:GridTest
	var symbolsTest:SymbolsTest
	var priceTest:PriceTest

	init(withSession session: Session) {
	
		
		week = session.week
		day = session.day
		self.session = session.session
		session_id = "\(session.sessionID)"
		sessionDate = session.sessionDate?.timeIntervalSince1970
		startTime = session.startTime?.timeIntervalSince1970
		participant_id = "\(Arc.shared.participantId!)"
		
		missedSession = (session.missedSession) ? 1 : 0
		finishedSession = (session.finishedSession) ? 1 : 0
		
		device_id = Arc.shared.deviceId
		device_info = Arc.shared.deviceInfo()
		app_version = Arc.shared.versionString
		model_version = "\(Arc.shared.arcVersion)"

		//All sessions have been prefilled with json data at the begining of the study
		contextSurvey = session.getSurveyFor(surveyType: .context)!.get()!
		gridTest = session.getSurveyFor(surveyType: .gridTest)!.get()!
		priceTest = session.getSurveyFor(surveyType: .priceTest)!.get()!
		symbolsTest = session.getSurveyFor(surveyType: .symbolsTest)!.get()!
		
		id = contextSurvey.id!

	}
}

public struct SurveySession : Codable {
	var id:String
	var week:Int64?
	var	day:Int64?
	var session:Int64?
	var	session_id:String? //"[some unique identifier that will always identify this session]",
	var	sessionDate:TimeInterval? //1503937447.437798,
	var startTime:TimeInterval? // 1503937447.732328,
	var participant_id:String? //"111111",
	
	var missedSession:Int64? // 0,
	var finishedSession:Int64? // 1,
	var device_id:String // "[device id]",
	var device_info:String // "iOS|iPhone8,4|10.1.1",
	var app_version:String // "1.2.4",
	var model_version:String // "1",
	
	var survey: SurveyResponse
	
	
	init(withSession session: Session, pullingSurvey surveyType:SurveyType) {
		let data = session.getSurveyFor(surveyType: surveyType)
		id = data!.id!
		
		week = session.week
		day = session.day
		self.session = session.session
		session_id = "\(session.sessionID)"
		sessionDate = session.sessionDate?.timeIntervalSince1970
		startTime = session.startTime?.timeIntervalSince1970
		participant_id = "\(Arc.shared.participantId!)"
		
		missedSession = (session.missedSession) ? 1 : 0
		finishedSession = (session.finishedSession) ? 1 : 0
		
		device_id = Arc.shared.deviceId
		device_info = Arc.shared.deviceInfo()
		app_version = Arc.shared.versionString
		model_version = "\(Arc.shared.arcVersion)"
		
		survey = data!.get()!
		
	}
	
	
	
}

