//
//  ViewController.swift
//  Filmici
//
//  Created by D&M on 21.02.2017..
//  Copyright © 2017. Dunja Sasic. All rights reserved.
//

//import UIKit
//import SwiftyJSON

//struct Movie {
//    var reviewer: String = ""
//    var date: String = ""
//    var movieTitle: String = ""
//    var reviewTitle: String = ""
//    var summary: String = ""
//    var linkText: String = ""
//    var imageURL: String = ""
//    var image: UIImage? = nil
//    
//    init(reviewer: String,
//    date: String,
//    movieTitle: String,
//    reviewTitle: String,
//    summary: String,
//    linkText: String,
//    imageURL: String,
//    image: UIImage?)
//    {
//        self.reviewer = reviewer
//        self.date = date
//        self.movieTitle = movieTitle
//        self.reviewTitle = reviewTitle
//        self.summary = summary
//        self.linkText = linkText
//        self.imageURL = imageURL
//        self.image = image
//        
//         }
//    }

//class ViewController: UIViewController {
//    var movies: [Movie] = []
//   
//    
//    private func execTask(request: URLRequest, taskCallback: @escaping (Bool,
//        AnyObject?) -> ()) {
//        
//        let session = URLSession(configuration: URLSessionConfiguration.default)
//        print("THIS LINE IS PRINTED")
//        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
//            print("a ovo")
//            if let data = data {
//                let json = JSON(data: data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
//                print (json["num_results"])
//                if let number = Int(json["num_results"].stringValue){
//                   
//                    for i in 0..<number {
//                        let movie = Movie.init(reviewer: json["results"][i]["byline"].stringValue, date: json["results"][i]["publication_date"].stringValue, movieTitle: json["results"][i]["display_title"].stringValue, reviewTitle: json["results"][i]["headline"].stringValue, summary: json["results"][i]["summary_short"].stringValue, linkText: json["results"][i]["link"]["suggested_link_text"].stringValue, imageURL: json["results"][i]["link"]["url"].stringValue, image: nil)
//                            
//                        self.movies.append(movie)
//                    }
//                }
//               print(self.movies[0])
//                
//                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
//                    taskCallback(true, json as AnyObject?)
//                } else {
//                    taskCallback(false, json as AnyObject?)
//                }
//                
//            }
//        })
//        task.resume()
//    
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        print("JEL TI RADIS")
//        
//        let URLString = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=32f79cebddee48278fe32e14c47b3763"
//        let url = URL(string: URLString)
//        let request = URLRequest(url: url!)
//        execTask(request: request) { (ok, obj) in
//            
//            print("proslo")
//            
//        }
//        
//    }
//    
//
//    
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}
//
