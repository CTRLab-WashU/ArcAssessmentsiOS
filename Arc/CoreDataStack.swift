///
//  CoreDataStack.swift
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

open class CoreDataStack {
    // MARK: - Core Data stack
    static public var isSaving:Bool = false
    static public let shared = CoreDataStack()
    static public var useMockContainer = false {
        didSet {
            if useMockContainer {
                CoreDataStack.mockDefaults?.removePersistentDomain(forName: "edu.washu.arcMockDefaults")

            }
        }
    }
    static public var defaults = UserDefaults(suiteName: "com.healthyMedium.arcdefaults");
    static public var mockDefaults = UserDefaults(suiteName: "edu.washu.arcMockDefaults");
    
    static public func currentDefaults() -> UserDefaults? {
        if useMockContainer {
            return mockDefaults
        }
        return defaults
    }
    
    lazy public var mockPersistantContainer: NSPersistentContainer = {
        
		
        return initializeMockStore()
    }()
	public func initializeMockStore() -> NSPersistentContainer {
		CoreDataStack.useMockContainer = true
		let container = NSPersistentContainer(name: "dianarc", managedObjectModel: self.managedObjectModel)
		let description = NSPersistentStoreDescription()
		description.type = NSInMemoryStoreType
		description.shouldAddStoreAsynchronously = false // Make it simpler in test env
		
		container.persistentStoreDescriptions = [description]
		container.loadPersistentStores { (description, error) in
			// Check if the data store is in memory
			precondition( description.type == NSInMemoryStoreType )
			
			// Check if creating container wrong
			if let error = error {
				fatalError("Create an in-mem coordinator failed \(error)")
			}
		}
		return container
	}
    lazy public var persistentContainer: NSPersistentContainer = {
		
		if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil || CoreDataStack.useMockContainer{
			// Code only executes when tests are running
			return mockPersistantContainer
		}
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
		let container = NSPersistentContainer(name: "dianarc", managedObjectModel: self.managedObjectModel)
		if let description = container.persistentStoreDescriptions.first {
		
			description.shouldInferMappingModelAutomatically = false
			description.shouldMigrateStoreAutomatically = true
			
			container.persistentStoreDescriptions = [description]
		}

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    lazy public var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.module] )!
        return managedObjectModel
    }()
    public func saveContext () {
		DispatchQueue.main.async {[unowned self] in
			var context = self.persistentContainer.viewContext
			if context.hasChanges {
				context.performAndWait {

					do {
							try context.save()

						
					} catch {
						// Replace this implementation with code to handle the error appropriately.
						// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
						let nserror = error as NSError
						assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
					}
				}
			}
			context = ArcController.dataContext
			if context.hasChanges {
				context.performAndWait {

					do {

							try context.save()

					} catch {
						// Replace this implementation with code to handle the error appropriately.
						// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
						let nserror = error as NSError
						assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
					}
				}
			}
		}
//        print("Ending save.")


    }
}
