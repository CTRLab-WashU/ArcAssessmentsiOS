//
// ArcController.swift
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
/**
 
 
    If we want to save and fetch objects from some other source then we can do that here.
 
 
 
 */



import Foundation
import CoreData
public enum ACResult<T> {
    case success(T)
    case error(Error)
}
public protocol ArcControllerDelegate {
    func didCatch(errors : Error)
}
open class ArcController {
    public enum ControllerError : Error {
        case NotFound
    }
    public var container:NSPersistentContainer
	static public var dataContext:NSManagedObjectContext = {
			CoreDataStack.shared.persistentContainer.newBackgroundContext()
	}()
    public var delegate:ArcControllerDelegate?
	
	open var defaults:UserDefaults! = CoreDataStack.currentDefaults()

    public init(container:NSPersistentContainer = CoreDataStack.shared.persistentContainer) {
        self.container = container
    }
	public func new<T:NSManagedObject>() -> T {
		return T(context: ArcController.dataContext)
	}
    public func save<T:ArcCodable>(id:String, obj:T) -> T {
        //Enforce id's on objects
        do {
            var saved = obj
            saved.id = id
            let savedData = try JSONEncoder().encode(saved)
            
            let json:JSONData = fetch(id:id) ?? JSONData(context: ArcController.dataContext)
            json.id = id
            json.type = "\(obj.type!.rawValue)"
            json.data = savedData
            save()
            return saved
        } catch {
            fatalError("Invalid value : \(error)")
        }
    }
    
    public func createNewJSONData<T:ArcCodable>(id:String, obj:T) -> JSONData
    {
        do {
            var saved = obj
            saved.id = id
            let savedData = try JSONEncoder().encode(saved)
            
            let json:JSONData = JSONData(context: ArcController.dataContext)
            json.id = id
            json.type = "\(obj.type!.rawValue)"
            json.data = savedData
            return json;
        } catch {
            fatalError("Invalid value : \(error)")
        }
    }
    
    public func fetch(id:String) -> JSONData? {
        let fetch:NSFetchRequest<JSONData> = JSONData.fetchRequest()
        fetch.predicate = NSPredicate(format: "id == %@", id)
			
			
        var results:[JSONData]? = nil
		
		ArcController.dataContext.performAndWait {
			do {
				results = try ArcController.dataContext.fetch(fetch)
			}  catch {
				delegate?.didCatch(errors: error)
				fatalError("Could not fetch: \(error)")
			}
		}
		
        return results?.first
			
    }
    
	public func mark(filled id:String) -> JSONData? {
		guard let item = fetch(id: id) else {
			return nil
		}
		item.isFilledOut = true
		save()
        
        // Add the completed data to the session result
        Arc.shared.appController.dataCompleted(dataId: id, data: item)
    
		return item
	}
    public func fetch<T:NSManagedObject>(predicate:NSPredicate? = nil, sort:[NSSortDescriptor]? = nil, limit:Int? = nil) -> [T]? {
		var results:[T]? = nil
		
		if let fetchRequest:NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> {
			fetchRequest.predicate = predicate
			fetchRequest.sortDescriptors = sort
			if let limit = limit {
				fetchRequest.fetchLimit = limit
			}
			ArcController.dataContext.performAndWait {
				do {
					results = try ArcController.dataContext.fetch(fetchRequest)
				}  catch {
						delegate?.didCatch(errors: error)
				}
			}
		}
			
			
		
		return results
		
    }
    
    public func get<T:ArcCodable>(id:String) throws -> T {
        guard let result = fetch(id: id), let value:T = result.get() else {
            throw ArcController.ControllerError.NotFound
        }
        return value
    }
    
    @discardableResult public func delete<T:ArcCodable>(data:T) -> Bool {
        var success = false
        
        guard let id = data.id else {
            return success
        }
        let fetch:NSFetchRequest<JSONData> = JSONData.fetchRequest()
        fetch.predicate = NSPredicate(format: "id == %@", id)
        do {
        if let result = try ArcController.dataContext.fetch(fetch).first {
            ArcController.dataContext.delete(result)
            success = true
            save()
        }
        } catch {
            delegate?.didCatch(errors: error)
        }
        return success

    }
	
	public func delete(_ obj:NSManagedObject) {
		ArcController.dataContext.delete(obj)
		save()
	}
	public func delete(_ objs:[NSManagedObject]) {
		for obj in objs {
			ArcController.dataContext.delete(obj)
		}
		save()
	}
    public func save() {
		CoreDataStack.shared.saveContext()
			
    }
}

