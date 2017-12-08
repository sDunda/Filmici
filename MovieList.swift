//
//  Continent.swift
//  PhotoGallery
//
//  Created by Leonard Beus on 26/02/2017.
//  Copyright © 2017 Five. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class MovieList: NSManagedObject {
    @NSManaged private(set) var movies: Set<MovieModel>
    
    func insert(movies: Set<MovieModel>, in context: NSManagedObjectContext){
        let movieList: MovieList = context.insertObject()
        movieList.movies = movies
        
        let status = context.saveOrRollback()
        print("movie list created", status)
        
    }
   
    
}




extension MovieList: CoreDataManagedType {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(movies), ascending: false)]
    }
}
