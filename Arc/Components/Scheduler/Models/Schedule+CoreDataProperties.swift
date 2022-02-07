//
//  Schedule+CoreDataProperties.swift
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


extension Schedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var hasConfirmedDate: Bool
    @NSManaged public var hasScheduledNotifications: Bool
    @NSManaged public var participantID: Int64
    @NSManaged public var scheduleID: String?
    @NSManaged public var createdOn: Date?
    @NSManaged public var testEndDate: Date?
    @NSManaged public var testStartDate: Date?
    @NSManaged public var userEndDate: Date?
    @NSManaged public var userStartDate: Date?
    @NSManaged public var scheduleEntries: Set<ScheduleEntry>?
    @NSManaged public var sessions: Set<Session>?

}

// MARK: Generated accessors for scheduleEntries
extension Schedule {

    @objc(addScheduleEntriesObject:)
    @NSManaged public func addToScheduleEntries(_ value: ScheduleEntry)

    @objc(removeScheduleEntriesObject:)
    @NSManaged public func removeFromScheduleEntries(_ value: ScheduleEntry)

    @objc(addScheduleEntries:)
    @NSManaged public func addToScheduleEntries(_ values: NSSet)

    @objc(removeScheduleEntries:)
    @NSManaged public func removeFromScheduleEntries(_ values: NSSet)

}

// MARK: Generated accessors for sessions
extension Schedule {

    @objc(insertObject:inSessionsAtIndex:)
    @NSManaged public func insertIntoSessions(_ value: Session, at idx: Int)

    @objc(removeObjectFromSessionsAtIndex:)
    @NSManaged public func removeFromSessions(at idx: Int)

    @objc(insertSessions:atIndexes:)
    @NSManaged public func insertIntoSessions(_ values: [Session], at indexes: NSIndexSet)

    @objc(removeSessionsAtIndexes:)
    @NSManaged public func removeFromSessions(at indexes: NSIndexSet)

    @objc(replaceObjectInSessionsAtIndex:withObject:)
    @NSManaged public func replaceSessions(at idx: Int, with value: Session)

    @objc(replaceSessionsAtIndexes:withSessions:)
    @NSManaged public func replaceSessions(at indexes: NSIndexSet, with values: [Session])

    @objc(addSessionsObject:)
    @NSManaged public func addToSessions(_ value: Session)

    @objc(removeSessionsObject:)
    @NSManaged public func removeFromSessions(_ value: Session)

    @objc(addSessions:)
    @NSManaged public func addToSessions(_ values: NSOrderedSet)

    @objc(removeSessions:)
    @NSManaged public func removeFromSessions(_ values: NSOrderedSet)

}
