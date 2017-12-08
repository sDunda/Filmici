//
//  Photo.swift
//  PhotoGallery
//
//  Created by Leonard Beus on 26/02/2017.
//  Copyright © 2017 Five. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public final class MovieModel: NSManagedObject  {
    //var imageMovie: UIImage?
    @NSManaged var reviewAuthorTitle: String
    @NSManaged var reviewDateTitle: String
    @NSManaged var summary: String
    @NSManaged var titleMovie: String
    @NSManaged var webLink: String
    @NSManaged var movieList: MovieList?
    
    
    
    
//    override public func prepareForDeletion() {
//        //delete country as well if there is no photos
//        if country.photos.filter({ !$0.isDeleted }).isEmpty {
//            managedObjectContext?.delete(country)
//        }
//    }
//    
    static func insert(into context: NSManagedObjectContext,
                      // imageMovie: UIImage?,
                       reviewAuthorTitle: String,
                       reviewDateTitle: String,
                       summary: String,
                       titleMovie: String,
                       webLink: String,
                       completion: @escaping (MovieModel) -> () ) {
        context.perform {
            let movie: MovieModel = context.insertObject()
           // movie.imageMovie = imageMovie
            movie.reviewAuthorTitle = reviewAuthorTitle
            movie.reviewDateTitle = reviewDateTitle
            movie.summary = summary
            movie.titleMovie = titleMovie
            movie.webLink = webLink
            movie.movieList = MovieList.findOrCreate(in: context, matching: NSPredicate(value: true), configure: { _ in })
            let status = context.saveOrRollback()
            print("context saved:", status)
            completion(movie)
        }
    }
}

extension MovieModel: CoreDataManagedType {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(titleMovie), ascending: false)]
    }
}
