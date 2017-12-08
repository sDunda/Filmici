//
//  MovieComment.swift
//  
//
//  Created by D&M on 11.03.2017..
//
//


import Foundation
import UIKit
import CoreData

final class MovieComment: NSManagedObject {
    @NSManaged private(set) var text: String
    @NSManaged private(set) var movie: MovieModel?
    
    
    static func insert(text: String,movieTitle: String, in context: NSManagedObjectContext,completion: @escaping (MovieComment) -> ()){
        let movieComment: MovieComment = context.insertObject()
        movieComment.text = text
        movieComment.movie = MovieModel.findOrCreate(in: context, matching: NSPredicate(format: "titleMovie == '\(movieTitle)'"), configure: {_ in })
        
        let status = context.saveOrRollback()
        print("comment created", status)
        completion(movieComment)
    }
    
    
}

extension MovieComment: CoreDataManagedType {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(text), ascending: false)]
    }
}
