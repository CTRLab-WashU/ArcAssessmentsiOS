//
//  TestManagerController.swift
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
open class TestController<T:ArcTestCodable> : ArcController {
    public enum ResponseError : Error {
        case invalidInput
        case invalidQuestionIndex
        case testNotStarted
    }
    
    public func get(response id:String) throws -> T {
        return try get(id: id)
    }
    
    public func get(testStartTime id:String) throws -> Date {
        let test = try get(response: id)
        guard let testDate = test.date else {
            throw TestController.ResponseError.testNotStarted
        }
        
        return Date(timeIntervalSince1970: testDate)
        
    }
    public func start(test id:String) -> T? {
        do {
            var test = try get(response: id)
            test.date = Date().timeIntervalSince1970
            return save(id: id, obj: test)
            
        } catch {
            
            delegate?.didCatch(errors: error)
        }
        
        return nil
        
    }
    public func get(timeSinceStart id:String) throws -> TimeInterval {
        let testDate = try get(testStartTime: id)
        return Date().timeIntervalSince(testDate)
        
    }
}
