//
//  Event+Common.swift
//  Arc
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

public class Event<T> {

  public typealias EventHandler = (T) -> ()

	fileprivate var eventHandlers = [Invocable]()

  public func raise(data: T) {
  for handler in self.eventHandlers {
	handler.invoke(data: data)
    }
  }

  public func addHandler<U: AnyObject>(target: U,
									   handler: @escaping (U) -> EventHandler) -> Disposable {
    let wrapper = EventHandlerWrapper(target: target,
                         handler: handler, event: self)
    eventHandlers.append(wrapper)
    return wrapper
  }
}

private protocol Invocable: class {
  func invoke(data: Any)
}


private class EventHandlerWrapper<T: AnyObject, U>
                                  : Invocable, Disposable {
  weak var target: T?
  let handler: (T) -> (U) -> ()
  let event: Event<U>

	init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>) {
    self.target = target
    self.handler = handler
    self.event = event;
  }

  func invoke(data: Any) -> () {
    if let t = target, let data = data as? U{
		handler(t)(data)
    }
  }

  func dispose() {
    event.eventHandlers =
       event.eventHandlers.filter { $0 !== self }
  }
}

public protocol Disposable {
  func dispose()
}
