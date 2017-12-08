//
//  PersistanceService.swift
//  PhotoGallery
//
//  Created by Leonard Beus on 26/02/2017.
//  Copyright © 2017 Five. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class PersistanceService {
    
    private var storeURL: URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return URL(fileURLWithPath: paths).appendingPathComponent("PhotoGallery.sqlite")
    }
    
    private var managedModel: NSManagedObjectModel!
    private var persistanceCoordinator: NSPersistentStoreCoordinator!
    fileprivate var mainContext: NSManagedObjectContext!

    
    init() {
        guard let model = NSManagedObjectModel.mergedModel(from: Bundle.allBundles) else {
            fatalError("model not found")
        }
        managedModel = model
        
        let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true]
        
        persistanceCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
        do {
            try persistanceCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                          configurationName: nil,
                                                          at: storeURL,
                                                          options: mOptions)
        } catch (_) {
            fatalError("failed to add persistent store")
        }
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = persistanceCoordinator
        
        print("store URL:", storeURL.absoluteString)
    }
    
    func fetchController<T: NSFetchRequestResult>(forRequest request: NSFetchRequest<T>) -> NSFetchedResultsController<T> {
        guard let mainContext = mainContext else {
            fatalError("coludn't get managed context")
        }
        
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: mainContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
}

extension PersistanceService {
    
    func createMovie(reviewAuthorTitle: String,
                     reviewDateTitle: String,
                     summary: String,
                     titleMovie: String,
                     webLink: String,
                     completion: @escaping (MovieModel) -> ()) {
        guard let mainContext = mainContext else {
            fatalError("context not available")
        }
        
        MovieModel.insert(into: mainContext, reviewAuthorTitle: reviewAuthorTitle,
                          reviewDateTitle: reviewDateTitle,
                          summary: summary,
                          titleMovie: titleMovie,
                          webLink: webLink) { movie in
                            completion(movie)
        }
    }
    
    func createComment(text:String,
                       movieTitle: String,
                     completion: @escaping (MovieComment) -> ()) {
        guard let mainContext = mainContext else {
            fatalError("context not available")
        }
    
        MovieComment.insert(
                            text: text,
                            movieTitle: movieTitle
                            , in: mainContext)
        { comment in
            completion(comment)
        }

        
        }
    }
    
