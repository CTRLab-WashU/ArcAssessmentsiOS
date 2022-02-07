// ArcOperation.swift
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

public class ArcOperation {
    public enum ConcurrencyMode {
        case serial
        case multi(Int)
        case unlimited
    }
    public enum OperationStatus {
        case complete
        case failed
        case cancelled
    }
    var complete:Bool = false
    let dispatchGroup:DispatchGroup = DispatchGroup()
    let queue:OperationQueue = OperationQueue()
    public init(_ concurrencyMode:ConcurrencyMode = .unlimited) {
        switch concurrencyMode {
        case .serial:
            queue.maxConcurrentOperationCount = 1
        case .multi(let opCount):
            queue.maxConcurrentOperationCount = opCount
        case .unlimited:
            queue.maxConcurrentOperationCount = -1
            
        }
    }
    public func sync(operations:[()->OperationStatus]) {
        
        
        print("performing tasks")
        var status:OperationStatus = .complete
        for op in operations {
            guard status == .complete else {
                print("failed")
                break
            }
            dispatchGroup.enter()
            queue.addOperation {
                status = op()
                print(status)
                self.dispatchGroup.leave()
                
            }
            dispatchGroup.wait()
        }
        dispatchGroup.wait()
        complete = true
        print("completed")
        
    }
    public func async(operations:[()->Void]) {
        
        
        print("performing tasks")
        for op in operations {
            
            dispatchGroup.enter()
            queue.addOperation {
                op()
                self.dispatchGroup.leave()
            }
        }
        dispatchGroup.wait()
        complete = true
        
    }
}
