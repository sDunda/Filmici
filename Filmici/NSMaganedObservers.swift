//
//  NSManagedObjectContext+Observers.swift
//  PhotoGallery
//
//  Created by Leonard Beus on 26/02/2017.
//  Copyright © 2017 Five. All rights reserved.
//

import Foundation
import CoreData


struct ObjectsDidChangeNotification {
    
    fileprivate let notification: Notification
    
    fileprivate func objects(forKey key: String) -> Set<NSManagedObject> {
        return ((notification as NSNotification).userInfo?[key] as? Set<NSManagedObject>) ?? Set()
    }
    
    init(note: Notification) {
        assert(note.name == NSNotification.Name.NSManagedObjectContextObjectsDidChange)
        notification = note
    }
    
    var insertedObjects: Set<NSManagedObject> {
        return objects(forKey: NSInsertedObjectsKey)
    }
    
    var updatedObjects: Set<NSManagedObject> {
        return objects(forKey: NSUpdatedObjectsKey)
    }
    
    var deletedObjects: Set<NSManagedObject> {
        return objects(forKey: NSDeletedObjectsKey)
    }
    
    var refreshedObjects: Set<NSManagedObject> {
        return objects(forKey: NSRefreshedObjectsKey)
    }
    
    var invalidatedObjects: Set<NSManagedObject> {
        return objects(forKey: NSInvalidatedObjectsKey)
    }
    
    var invalidatedAllObjects: Bool {
        return (notification as NSNotification).userInfo?[NSInvalidatedAllObjectsKey] != nil
    }
    
    var managedObjectContext: NSManagedObjectContext {
        guard let c = notification.object as? NSManagedObjectContext else { fatalError("Invalid notification object") }
        return c
    }
}


extension NSManagedObjectContext {
    
    func addObjectsDidChangeNotificationObserver(_ handler: @escaping (ObjectsDidChangeNotification) -> ()) -> NSObjectProtocol {
        let nc = NotificationCenter.default
        return nc.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: self, queue: nil) { note in
            let wrappedNote = ObjectsDidChangeNotification(note: note)
            handler(wrappedNote)
        }
    }
    
}
