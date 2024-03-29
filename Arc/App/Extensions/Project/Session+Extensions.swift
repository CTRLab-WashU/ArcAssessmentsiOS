//
//  Session+Extensions.swift
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
import CoreData
public extension Session {
	
    func isAvailableForState(state:State) -> Bool {
		
		let surveyType = state.surveyTypeForState()
		guard let survey = surveyFor(surveyType: surveyType) else {
			return false
		}
		
		return !survey.isFilledOut

	}
	
    func isLastSession() -> Bool
	{
		if self.study == nil || self.study!.sessions == nil
		{
			return false;
		}
		
		return self.study!.sessions!.index(of: self) == self.study!.sessions!.count - 1;
	}
	
    func isFirstSession() -> Bool
	{
		if self.study == nil || self.study!.sessions == nil
		{
			return false;
		}
		
		return self.study!.sessions!.index(of: self) == 0;
	}
	
    func hasTakenWakeSurvey() -> Bool
	{
		return true
	}
    func typeNamesForSession() -> [String] {
		let data = sessionData as! Set<JSONData>
		var set:Set<String> = []
		for obj in data {
			if ["gridTest","symbolsTest","priceTest","context", "chronotype","wake"].contains(obj.type) {
				set.insert(SurveyType.cognitive.rawValue)
			} else {
				set.insert( obj.type!)
			}
		}
		
		
		return Array(set)
	}
	
    func surveyFor(surveyType:SurveyType) -> JSONData? {
		let data = sessionData as! Set<JSONData>
		let obj = data.filter { (data) -> Bool in
			return data.type == surveyType.rawValue
		}
		return obj.first
	}
	// clears all useful data from the Session. It only keeps data related to start date, which Arc it's part of,
	// and whether or not it was finished or missed.
	
    func clearData()
	{
		let relationships = self.entity.relationshipsByName;
		
		// delete all of the relationships
		for (name, _) in relationships
		{
			if name == "study"
			{
				continue;
			}
			
			if let v = self.value(forKey: name) as? NSManagedObject
			{
				CoreDataStack.shared.persistentContainer.newBackgroundContext().delete(v)
			}
		}
		
		// and now clear out any data we don't absolutely need to keep the app running
//		self.completeTime = nil;
		self.endSignature = nil;
		self.startSignature = nil;
//		self.startTime = nil;
		self.willUpgradePhone = false;
		self.interrupted = false;
		
		CoreDataStack.shared.saveContext()
		
		// and now, delete any notifications
		
//		NotificationEntry.clearPastNotifications();
		
	}
	
    func createSurveyFor(surveyType:SurveyType, id:String = UUID().uuidString) {
		switch surveyType {
		case .edna, .ema, .context, .mindfulness, .chronotype, .wake:
			let surveyController = Arc.shared.surveyController
			let survey = surveyController.create(surveyResponse: id, type: surveyType)
			let data = surveyController.fetch(id: survey)
			data?.type = surveyType.rawValue
			self.addToSessionData(data!)
			
		case .gridTest:
			let controller = Arc.shared.gridTestController
			let test = controller.createResponse(id: id, numSections: 2)
			let data = controller.fetch(id: test)
			data?.type = surveyType.rawValue
            self.addToSessionData(data!)
            
		case .priceTest:
			let controller =  Arc.shared.pricesTestController
			let priceTest = controller.loadTest(index: Int(sessionID), file: PricesTestViewController.testVersion)
			let response = controller.createResponse(id: id, withTest: priceTest)
			let data = controller.fetch(id: response)
			data?.type = surveyType.rawValue
			self.addToSessionData(data!)
            
		case .symbolsTest:
			let controller = Arc.shared.symbolsTestController
			let test = controller.generateTest(numSections: 12, numSymbols: 8)
			let response = controller.createResponse(withTest: test, id:id)
			let data = controller.fetch(id: response)
			data?.type = surveyType.rawValue
			self.addToSessionData(data!)
            
		default:
			break
		}
	}
    
    
    func createGridTest() -> GridTestResponse
    {
        let controller = Arc.shared.gridTestController
        let test = controller.createGridTestResponse(numSections: 2)
        return test;
    }
    
    func createPriceTest() -> PriceTestResponse
    {
        let controller =  Arc.shared.pricesTestController
        let priceTest = controller.loadTest(index: Int(sessionID), file: PricesTestViewController.testVersion)
        let response = controller.createPriceTestResponse(withTest: priceTest)
        return response;
    }
    
    func createSymbolsTest() -> SymbolsTestResponse
    {
        let controller = Arc.shared.symbolsTestController
        let test = controller.generateTest(numSections: 12, numSymbols: 8)
        let response = controller.createSymbolsTestResponse(withTest: test)
        return response;
    }
    
    func createSurveyTest(surveyType:SurveyType) -> SurveyResponse
    {
        let surveyController = Arc.shared.surveyController
        let survey = surveyController.createSurveyResponse(type: surveyType)
        return survey
    }
    
    
    
    func getSurveyFor(surveyType:SurveyType) -> JSONData?
	{
		let data = sessionData as! Set<JSONData>
		return data.first(where: { (obj) -> Bool in
			return obj.type == surveyType.rawValue
		})
	}

    func getCognitiveSurveyFor(surveyType:SurveyType) -> JSONData? {
        // Cognitive assessment tutorials come through with
        // multiple result types, so choose the one with the largest data
        return (sessionData as! Set<JSONData>).filter {
            $0.type == surveyType.rawValue
        }.sorted { data1, data2 in
            (data1.data?.count ?? 0) > (data2.data?.count ?? 0)
        }.first
    }
}
