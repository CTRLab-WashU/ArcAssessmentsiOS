//
//  StudyProgress.swift
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

public struct StudyProgress : Codable {
    public var response: Response?

    public struct Response : Codable {
        public var success:Bool
        public var study_progress:Progress?
        
        public struct Progress : Codable {
            public var cycle_count:Int
            public var current_cycle:Int
            public var joined_date:TimeInterval
            public var finish_date:TimeInterval
        }
    }
}

public struct CycleProgress : Codable {
    public var response: Response?
    
    public struct Response : Codable {
        public var success:Bool
        public var cycle_progress:Progress?
        
        public struct Progress : Codable {
            public var cycle:Int
            public var start_date:TimeInterval?
            public var end_date:TimeInterval
            public var day_count:Int
            public var current_day:Int?
            public var days:[Day]
            
            public struct Day : Codable {
                public var start_date:TimeInterval?
                public var end_date:TimeInterval?
                public var day:Int
                public var cycle:Int
                public var sessions:[Session]
                
                public struct Session : Codable {
                    public var session_index:Int
                    public var session_date:TimeInterval
                    public var status:String
                    public var percent_complete:Int
                }
            }
        }
    }
}

// creating dictionary for the session and session status
public extension CycleProgress.Response{
    var asDictionary: [Int:String] {
        guard let progress = cycle_progress else { return [:]}
        var result: [Int:String] = [:]
        
        for day in progress.days {
            for session in day.sessions
            {
                result[session.session_index] = session.status
            }
        }
        return result
    }
}

public struct DayProgress : Codable {
    
    public struct Response : Codable {
        public var success:Bool
        public var day_progress:Progress
        
        public struct Progress : Codable {
            public var start_date:TimeInterval
            public var end_date:TimeInterval
            public var day:Int
            public var cycle:Int
            public var sessions:[Session]
            
            public struct Session : Codable {
                public var session_index:Int
                public var session_date:TimeInterval
                public var status:String
                public var percent_complete:Int
            }
        }        
    }
}

public struct CycleProgressRequestData:Codable {
    
    var cycle:Int?   //index of the cycle to retrieve
    
    init(cycle:Int?) {
        self.cycle = cycle
    }
}

public struct DayProgressRequestData:Codable {
    
    var cycle:Int?   //index of the cycle to retrieve
    var day:Int?     //index of the day of the cycle
    
    init(cycle:Int?, day:Int?) {
        self.cycle = cycle
        self.day = day
    }
    
}
