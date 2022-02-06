//
//  AppController.swift
// Arc
//
//  Created by Philip Hayes on 10/26/18.
//  Copyright © 2018 healthyMedium. All rights reserved.
//

import Foundation
import UIKit

open class AppController : MHController {
    
    public var currentSessionID: Int64 = 0
    
	public enum Commitment : String, Codable {
		case committed, rebuked
	}
	
	public var testCount:Int = 0
    
    public func startNewTest(info: ArcAssessmentSupplementalInfo? = nil) {
        self.currentSessionID = info?.sessionID ?? 0
        self.createNewSession(info: info)
    }
	
	public func store<T:Codable>(value:T?, forKey key:String) {
		defaults.setValue(value?.encode(), forKey:key);
		defaults.synchronize();
	}
	public func delete(forKey key:String) {
		defaults.removeObject(forKey: key)
		defaults.synchronize();
	}
	public func read<T:Codable>(key:String) -> T? {
		guard let value:T =  defaults.data(forKey: key)?.decode() else {
			
			return nil
		}
		return value
	}
	public var isParticipating:Bool {
		get {
			if let value = (defaults.value(forKey:"isParticipating") as? Bool)
			{
				return value;
			}
			return false;
		}
		set (newVal)
		{
			defaults.setValue(newVal, forKey:"isParticipating");
			defaults.synchronize();
		}
	}
	public var isNotificationAuthorized:Bool {
		get {
			if let value = (defaults.value(forKey:"isNotificationAuthorized") as? Bool)
			{
				return value;
			}
			return false;
		}
		set (newVal)
		{
			defaults.setValue(newVal, forKey:"isNotificationAuthorized");
			defaults.synchronize();
		}
	}
	public var flags:[String:Bool] {
		get {
			
			guard let value =  defaults.dictionary(forKey:"applicationFlags") as? [String : Bool] else {
				defaults.setValue([:], forKey:"applicationFlags");

				return defaults.dictionary(forKey:"applicationFlags") as! [String : Bool];
			}
			
			return value
		}
		set (newVal)
		{
			defaults.setValue(newVal, forKey:"applicationFlags");
			defaults.synchronize();
		}
	}
	
	//Use this to track the last time something had been fetched.
	//Api calls, periodic checks, event triggers
	public var lastFetched:[String:TimeInterval] {
		get {
			
			guard let value =  defaults.dictionary(forKey:"lastFetched") as? [String : TimeInterval] else {
				defaults.setValue([:], forKey:"lastFetched");
				
				return defaults.dictionary(forKey:"lastFetched") as! [String : TimeInterval];
			}
			
			return value
		}
		set (newVal)
		{
			defaults.setValue(newVal, forKey:"lastFetched");
			defaults.synchronize();
		}
	}
    
    public var locale:ACLocale {
        return ACLocale(rawValue: "\(language ?? "en")_\(country ?? "US")") ?? .en_US
    }
    
    public var language:String? {
        get {
            
            return defaults.string(forKey:"language");
            
        }
        set (newVal)
        {
            defaults.setValue(newVal, forKey:"language");
            defaults.synchronize();
        }
    }
    public var country:String? {
        get {
            
            return defaults.string(forKey:"country");
            
        }
        set (newVal)
        {
            defaults.setValue(newVal, forKey:"country");
            defaults.synchronize();
        }
    }
	public var participantId:Int? {
		get {

			if let id = defaults.value(forKey:"participantId") as? Int
			{
				return id;
			}
			return nil;
		}
		set (newVal)
		{
			defaults.setValue(newVal, forKey:"participantId");
			defaults.synchronize();
		}
	}
    public var lastFlaggedMissedTestCount:Int {
        get {
            
            if let id = defaults.value(forKey:"lastFlaggedMissedTestCount") as? Int
            {
                return id;
            }
            return 0;
        }
        set (newVal)
        {
            defaults.setValue(newVal, forKey:"lastFlaggedMissedTestCount");
            defaults.synchronize();
        }
    }
    public var isFirstLaunch:Bool {
        get {
            if (defaults.value(forKey:"hasLaunched") as? Bool) != nil
            {
                return false;
            }
            return true;
        }
        set (newVal)
        {
            defaults.setValue(true, forKey:"hasLaunched");
            defaults.synchronize();
        }
    }
    public var commitment:Commitment? {
        get {
			return Commitment(rawValue: defaults.string(forKey: "commitment") ?? "")
			
        }
        set (newVal)
        {
			defaults.setValue(newVal?.rawValue, forKey:"commitment");
			defaults.synchronize();
        }
    }
    public var deviceId:String {
        get {
            if let value = (defaults.value(forKey:"deviceId") as? String)
            {
                return value;
            }
            let id = UUID().uuidString;
            defaults.setValue(id, forKey:"deviceId");
            defaults.synchronize();
            return id
        }
        set (newVal)
        {
            defaults.setValue(newVal, forKey:"deviceId");
            defaults.synchronize();
        }
    }
	
	public var wakeSleepUploaded:Bool {
		get {
			if let value = (defaults.value(forKey:"wakeSleepUploaded") as? Bool)
			{
				return value;
			}
			return false;
		}
		set (newVal)
		{
			defaults.setValue(newVal, forKey:"wakeSleepUploaded");
			defaults.synchronize();
		}
	}
	public var testScheduleUploaded:Bool {
		get {
			if let value = (defaults.value(forKey:"testScheduleUploaded") as? Bool)
			{
				return value;
			}
			return false;
		}
		set (newVal)
		{
			defaults.setValue(newVal, forKey:"testScheduleUploaded");
			defaults.synchronize();
		}
	}

	public var lastClosedDate:Date?

	
	public var lastUploadDate:Date? {
		get {
			if let _lastUploadDate = defaults.value(forKey:"lastUploadDate") as? Date
			{
				return _lastUploadDate;
			}
			return nil;
		}
		set (newVal)
		{
			defaults.setValue(newVal, forKey:"lastUploadDate");
			defaults.synchronize();
		}
	}
    public var lastBackgroundFetch:Date? {
        get {
            if let _lastUploadDate = defaults.value(forKey:"lastBackgroundFetch") as? Date
            {
                return _lastUploadDate;
            }
            return nil;
        }
        set (newVal)
        {
            defaults.setValue(newVal, forKey:"lastBackgroundFetch");
            defaults.synchronize();
        }
    }
	public var lastWeekScheduled:Date? {
		get {
			if let _lastUploadDate = defaults.value(forKey:"lastWeekScheduled") as? Date
			{
				return _lastUploadDate;
			}
			return nil;
		}
		set (newVal)
		{
			defaults.setValue(newVal, forKey:"lastWeekScheduled");
			defaults.synchronize();
		}
	}
    
    public func save(signature image:UIImage, sessionId:Int64, tag:Int32) -> Bool {
        guard let data = image.pngData() else {
            return false
        }
        
        if (tag == 0) {
            MHController.dataContext.perform {
                let session = self.getSessionResult(sessionId: sessionId)
                session?.startSignature = data
                self.save()
            }
        } else if (tag == 1) {
            MHController.dataContext.perform {
                let session = self.getSessionResult(sessionId: sessionId)
                session?.endSignature = data
                self.save()
            }
        }
        
        return true
    }

    public func timePeriodPassed(key:String, date:Date) -> Bool {
        guard let t = Arc.shared.appController.lastFetched[key] else {
            return true
        }
        return t < date.timeIntervalSince1970
    }
    
    public func dataCompleted(dataId: String, data: JSONData) {
        MHController.dataContext.performAndWait {
            guard let currentSession = self.getSessionResult(sessionId: self.currentSessionID) else {
                print("Could not find current session, make sure session id is set in AppController")
                return
            }
            currentSession.removeFromSessionData(data)
            currentSession.addToSessionData(data)
            self.save()
        }
    }
    
    public func getCurrentSessionResult() -> Session? {
        return getSessionResult(sessionId: self.currentSessionID)
    }
    
    private func deletePrevSessionResults(sessionId: Int64) {
        MHController.dataContext.performAndWait {
            self.getSessionResults(sessionId: sessionId).forEach { session in
                MHController.dataContext.delete(session)
            }
            self.save()
        }
    }
    
    private func getSessionResults(sessionId: Int64) -> [Session] {
        let predicate = NSPredicate(format: "sessionID == \(sessionId)")
        let sortDescriptors = [NSSortDescriptor(key:"sessionDate", ascending:true)]
        let results:[Session] = fetch(predicate: predicate, sort: sortDescriptors) ?? []
        return results
    }
    
    public func getSessionResult(sessionId: Int64) -> Session? {
        return self.getSessionResults(sessionId: sessionId).first
    }
    
    open func createNewSession(info: ArcAssessmentSupplementalInfo? = nil) {
        let sessionId = info?.sessionID ?? 0
        self.deletePrevSessionResults(sessionId: sessionId)
        MHController.dataContext.performAndWait {
            let newSession: Session = self.new()
            newSession.sessionID = sessionId
            newSession.startTime = Date()
            newSession.sessionDate = info?.sessionDate
            newSession.expirationDate = info?.sessionDate.addingHours(hours: 2)
            newSession.week = info?.week ?? 0
            newSession.day = info?.day ?? 0
            newSession.session = info?.session ?? 0
            self.save()
        }
    }
}

public extension Encodable {
    func encode(outputFormatting: JSONEncoder.OutputFormatting? = [.prettyPrinted, .sortedKeys]) -> Data? {
        do {
            let encoder = JSONEncoder()
            if let outputFormatting = outputFormatting {
                encoder.outputFormatting = outputFormatting
            }
            return try encoder.encode(self)
        } catch {
            print(error)
            return nil
        }
        
    }
    func toString(outputFormatting:JSONEncoder.OutputFormatting? =  [.prettyPrinted, .sortedKeys]) -> String {
        
        guard let data = self.encode(outputFormatting: outputFormatting), let string = String(data: data, encoding: .utf8) else {
            return ""
        }
        return  string
    }
}

public extension Data {
    func decode<T:Decodable>() -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch {
            print(error)
            return nil
        }
        
    }
    mutating func appendString(value:String?) {
        guard let data = value?.data(using: String.Encoding.utf8) else {
            return
        }
        self.append(contentsOf: data)
    }
}

public enum ACLocale : String{
/*
     US - English    Nederland - Nederlands    France - Français    España - Español    Argentina - Español    Canada - Français    Deutschland - Deutsche    Italia - Italiano    日本 - 日本語    Brasil - Português    Columbia - Español    Mexico - Español    US - Español    中国 - 简体中文
     
     language_key    en    nl    fr    es    es    fr    de    it    ja    pt    es    es    es    zh
      country_key    US    NL    FR    ES    AR    CA    DE    IT    JP    BR    CO    MX    US    CN
*/
    case en_US
    case en_AU
    case en_GB
    case en_CA
    case en_IE
    case ko_KR
    case nl_NL
    case fr_FR
    case es_ES
    case es_AR
    case es_419
    case fr_CA
    case de_DE
    case it_IT
    case ja_JP
    case pt_BR
    case es_CO
    case es_MX
    case es_US
    case zh_CN
    
    static func from(description:String) -> ACLocale {
        switch description {
            
        case "US - English": return .en_US
        case "Australia - English": return .en_AU
        case "UK - English": return .en_GB
        case "Canada - English": return .en_CA
        case "Ireland - English": return .en_IE
        case "NL - Nederlands": return .nl_NL
        case "France - Français": return .fr_FR
        case "España - Español": return .es_ES
        case "Europe - Spanish": return .es_ES
        case "Europa - Español": return .es_ES
            
        case "대한민국-한국어": return .ko_KR

        case "Argentina - Español": return .es_AR
        case "Canada - Français": return .fr_CA
        case "Canada - French": return .fr_CA

        case "Deutschland - Deutsche": return .de_DE
        case "Germany - German": return .de_DE

        case "Italia - Italiano": return .it_IT
        case "日本 - 日本語": return .ja_JP
        case "Japan - Japanese": return .ja_JP

        case "Brasil - Português": return .pt_BR
        case  "Columbia - Español": return .es_CO
        case  "Colombia - Español": return .es_CO

        case "Mexico - Español": return .es_MX
        case "Latin America - Spanish": return .es_419
        case "America Latina - Español": return .es_419

        case "US - Español": return .es_US
        case "中国 - 简体中文": return .zh_CN
        default: return .en_US
            
        }
        
    }
    var string: String {
        return self.rawValue
    }
    var locale:(language:String, region:String) {
        let values = string.components(separatedBy: "_")
        return (values[0], values[1])
    }
    func getLocale() -> Locale {
        return Locale(identifier: string)
    }
    var availablePriceTest:String {
    let value = "prices/\(self.rawValue)/price_sets"
       return value
    }
}

public struct ArcAssessmentSignature {
    // The PNG data of a UIImage
    public var data: Data
    // The tag can be used to differentiate between multiple signatures in a session
    public var tag: Int32
}

public struct ArcAssessmentSupplementalInfo {
    public var sessionID: Int64
    public var sessionDate: Date
    public var week: Int64
    public var day: Int64
    public var session: Int64
    
    public init(sessionID: Int64,
                sessionAvailableDate: Date,
                weekInStudy: Int64,
                dayInWeek: Int64,
                sessionInDay: Int64) {
        
        self.sessionID = sessionID
        self.sessionDate = sessionAvailableDate
        self.week = weekInStudy
        self.day = dayInWeek
        self.session = sessionInDay
    }
}
