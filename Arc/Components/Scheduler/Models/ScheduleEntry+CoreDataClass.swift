//
//  ScheduleEntry+CoreDataClass.swift
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

//@objc(ScheduleEntry)
@available(*, deprecated)
open class ScheduleEntry: NSManagedObject {
	public var day:WeekDay {
		get {
			return WeekDay(rawValue:self.weekday)!
		}
		set {
			self.weekday = newValue.rawValue
		}
	}
	public func startTimeOn(date:Date) -> Date? {
		let formatter = DateFormatter()
		formatter.defaultDate = date
		formatter.dateFormat = "h:mm a"
		
		return formatter.date(from: availabilityStart ?? "")
	}
	
    // returns the end time for the given date.
    // If the availabilityEnd is "before" availabilityStart
    // (ie they wake up at 2pm and go to bed at 4 pm)
    // then we increment the date by one.
    
	public func endTimeOn(date:Date) -> Date? {
		let formatter = DateFormatter()
		formatter.defaultDate = date
		formatter.dateFormat = "h:mm a"
		
		var endTime = formatter.date(from: availabilityEnd ?? "")
        let startTime = self.startTimeOn(date: date);
        
        if let e = endTime, let s = startTime, s.compare(e) == .orderedDescending
        {
            endTime = e.addingDays(days: 1);
        }
        
        return endTime;
	}
}
