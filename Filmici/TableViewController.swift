//
//  TableViewController.swift
//  Filmici
//
//  Created by D&M on 21.02.2017..
//  Copyright © 2017. Dunja Sasic. All rights reserved.
//

import UIKit
import SwiftyJSON
import Dispatch
import CoreData
import Foundation

struct Movie {
    var reviewer: String = ""
    var date: String = ""
    var movieTitle: String = ""
    var reviewTitle: String = ""
    var summary: String = ""
    var linkText: String = ""
    var imageURL: String = ""
    var image: UIImage? = nil
    var linkURL: String = ""
    
    init(reviewer: String,
         date: String,
         movieTitle: String,
         reviewTitle: String,
         summary: String,
         linkText: String,
         imageURL: String,
         image: UIImage?,
         linkURL: String)
    {
        self.reviewer = reviewer
        self.date = date
        self.movieTitle = movieTitle
        self.reviewTitle = reviewTitle
        self.summary = summary
        self.linkText = linkText
        self.imageURL = imageURL
        self.image = image
        self.linkURL = linkURL

    }
}

class TableViewController: UIViewController {
    
 
    
    fileprivate let cellIdentifier = String(describing: TableViewCell.self)
    
    @IBOutlet private weak var tableView: UITableView!
    var request: URLRequest?
    var movies: [Movie] = []
    var allMovies: [String] = []
    var allImageURLs: [String] = []
    var images: [UIImage?] = []
    var image: UIImage? = nil
    let URLString = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=32f79cebddee48278fe32e14c47b3763"
    
    fileprivate var persistanceService: PersistanceService?

    var frc: NSFetchedResultsController<NSFetchRequestResult>!

    convenience init(persistanceService: PersistanceService?) {
        self.init()
        self.persistanceService = persistanceService
    }

    func saveToContext(){
        movies.forEach({movie in
            persistanceService?.createMovie(reviewAuthorTitle: movie.reviewer, reviewDateTitle: movie.date, summary: movie.summary, titleMovie: movie.movieTitle, webLink: movie.linkURL, completion: {_ in
                    print("movie created")
            })
        })
    }
    
     func execTask(request: URLRequest, taskCallback: @escaping (Bool,
        AnyObject?) -> ()) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            // go to main thread
            if let data = data {
                let json = JSON(data: data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
    
                if let number = Int(json["num_results"].stringValue){
                    
                    for i in 0..<number {
                        let movie = Movie.init(
                            reviewer: json["results"][i]["byline"].stringValue,
                            date: json["results"][i]["publication_date"].stringValue, movieTitle: json["results"][i]["display_title"].stringValue, reviewTitle: json["results"][i]["headline"].stringValue, summary: json["results"][i]["summary_short"].stringValue, linkText: json["results"][i]["link"]["suggested_link_text"].stringValue, imageURL: json["results"][i]["multimedia"]["src"].stringValue, image: nil, linkURL: json["results"][i]["link"]["url"].stringValue)
                        self.allMovies.append(json["results"][i]["display_title"].stringValue)
                        self.allImageURLs.append(json["results"][i]["multimedia"]["src"].stringValue)
                        self.movies.append(movie)
                
                    }
                }
                
                self.saveToContext()
                
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    taskCallback(true, json as AnyObject?)
                } else {
                    taskCallback(false, json as AnyObject?)
                }
                
            }
        })
        task.resume()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let req = NSFetchRequest(entityName: "MovieList")
        frc = persistanceService?.fetchController(forRequest: req)
       // frc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        
        let moc = dataController.managedObjectContext
        frc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        
        
        // create fetch request that fetches all movies
        // frc = // create frc with that fetch request
        frc.delegate = self

        tableView.register(
            UINib(nibName: cellIdentifier, bundle: nil),
            forCellReuseIdentifier: cellIdentifier
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppActivation),
            name: NSNotification.Name.UIApplicationWillEnterForeground,
            object: nil
        )
        
        
    
        self.handleAppActivation()
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.title = "Movies"

            }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        

    }
    
    
    @objc func handleAppActivation() {
        DispatchQueue.global(qos: .background).sync {
            let url = URL(string: URLString)
            request = URLRequest(url: url!)
            if let request = self.request {
                print("proslo1")
                
                execTask(request: request) { [weak self](ok, obj) in
                    DispatchQueue.main.sync {
                        print("proslo")
                    }
                }
            }
            
        }
        
    }
}




extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of objects in frc
        return allMovies.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // fetch object at indexPath from frc
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
            let name = allMovies[indexPath.row]
            let urlName: String = allImageURLs[indexPath.row]
            cell.MovieTitle?.text = name
            let url = URL(string: urlName)
            DispatchQueue.global().sync {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    cell.MovieImage.image = UIImage(data: data!)
                    self.image = UIImage(data: data!)
                    self.images.append(self.image)
                }
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieViewController = MovieViewController(persistanceService: persistanceService, myMovie: movies[indexPath.row])
        movieViewController.image = images[indexPath.row]
     //   guard let object = dataSource?.objectAtIndexPath(indexPath) else { return }
        navigationController?.pushViewController(movieViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
}

extension TableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //tableView.reloadData()
    }
}
