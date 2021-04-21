//
//  PersistenceService.swift
//  BeenThere
//
//  Created by Peyton Shetler on 4/21/21.
//

import Foundation
import CoreData
import MapKit

typealias completionWithEither = (Result<Bool, BTError>) -> Void

class PersistenceService {
    
    private init() {}
    static let shared = PersistenceService()
    
    var context: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "BeenThere")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
            if let error = error as NSError? {
                print("Error with persistent container:  \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    func save (completion: @escaping completionWithEither) {
        if context.hasChanges {
            
            context.performAndWait {
                
                do {
                    try context.save()
                    completion(.success(true))
                } catch {
                    
                    completion(.failure(.savingError))
                }
            }
        }
    }
    
    
    func fetchAll<T: NSManagedObject>(_ type: T.Type, completed: @escaping(Result<[T], BTError>) -> Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        
        do {
            let objects = try context.fetch(request)
            completed(.success(objects))
        } catch {
            completed(.failure(.errorRetrievingResults))
        }
    }
    
    
    func placeExists(name: String) -> Bool {
        var exists: Bool = false

        let request = NSFetchRequest<NSNumber>(entityName: "BTPlace")
        let predicate = NSPredicate(format: "name = %@", name)
        request.predicate = predicate
        request.fetchLimit = 1
        request.resultType = .countResultType
        
        do {
            let countResult = try context.fetch(request)
            let count = countResult.first!.intValue
            if count > 0 {
                exists = true
            } else {
                exists = false
            }
           
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return exists
    }
    
    
    func getTagIfExists(name: String) -> BTTag? {
        var tag: BTTag? = nil

        let request = NSFetchRequest<BTTag>(entityName: "BTTag")
        let predicate = NSPredicate(format: "name = %@", name)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let tags = try context.fetch(request)
            if tags.count > 0 {
                tag = tags[0]
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return tag
    }
    
    func savePlace(name: String, isFavorite: Bool = false, note: String?, tag: BTTag, item: MKMapItem, completion: @escaping completionWithEither) {
        
        let place = BTPlace(context: context)
        place.name = name
        place.isFavorite = isFavorite
        
        place.tag = tag
    
        // TO DO:  Extract this into it's own function. Get rid of nil-coalescing, these values already have default values in the core data entity.
        let location = BTLocation(context: context)
        location.subThoroughfare = item.placemark.subThoroughfare ?? ""
        location.thoroughfare = item.placemark.thoroughfare ?? ""
        location.locality = item.placemark.locality ?? ""
        location.administrativeArea = item.placemark.administrativeArea ?? ""
        location.postalCode = item.placemark.postalCode ?? ""
        location.country = item.placemark.country ?? ""
        location.phoneNumber = item.phoneNumber ?? ""
        location.url = item.url?.absoluteString ?? ""
        location.latitude = item.placemark.coordinate.latitude
        location.longitude = item.placemark.coordinate.longitude
        
        place.location = location

        
        if let unwrappedNote = note, !unwrappedNote.isEmpty {
            place.note = note!
        }
        
        
        if context.hasChanges {
            
            context.performAndWait {
                
                do {
                    try context.save()
                    completion(.success(true))
                } catch {
                    
                    let error = error as NSError
                    print("Unresolved error \(error), \(error.userInfo)")
                    completion(.failure(.savingError))
                }
            }
        }
    }
}

