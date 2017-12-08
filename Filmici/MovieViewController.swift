//
//  MovieViewController.swift
//  Filmici
//
//  Created by D&M on 22.02.2017..
//  Copyright © 2017. Dunja Sasic. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    
    var myMovie: Movie!
    var image: UIImage!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var reviewAuthorTitle: UILabel!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var summary: UITextView!
    @IBOutlet weak var reviewDateTitle: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    @IBAction func saveComment(_ sender: UIButton) {
        if let comment = comment.text {persistanceService?.createComment(text: comment, movieTitle: myMovie.movieTitle, completion: {_ in print("comment saved: \(comment)")})}
    
    }
    
    
    @IBAction func webLink(_ sender: UIButton) {
        if let url = self.myMovie?.linkURL {
            let webViewController = WebView(url: url)
            navigationController?.pushViewController(webViewController, animated: true)
            self.navigationItem.title = myMovie.movieTitle
        }
    }
    
    fileprivate var persistanceService: PersistanceService?
    
    convenience init(persistanceService: PersistanceService?, myMovie: Movie) {
        self.init()
        self.persistanceService = persistanceService
        self.myMovie = myMovie
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleMovie.text = myMovie.movieTitle
        reviewAuthorTitle.text = myMovie.reviewer
        imageMovie.image = image
        summary.text = myMovie.summary
        reviewDateTitle.text = myMovie.date
        linkButton.setTitle("Read more details", for: .normal)
        linkButton.isHidden = true
        self.setAlpha(value: 0)
        self.setFrame(x: UIScreen.main.bounds.width)
        
        UIView.animate(withDuration: 1.5, animations: {
            self.setAlpha(value: 1)
            self.setFrame(x: 0)
        }, completion: { _ in
            self.linkButton.isHidden = false
        })
        
        
    }

        // Do any additional setup after loading the view.
    

    private func setFrame(x: CGFloat) {
        self.titleMovie.frame.origin.x = x
        self.reviewDateTitle.frame.origin.x = x
        self.reviewAuthorTitle.frame.origin.x = x
    }
    
    private func setAlpha(value: CGFloat) {
        self.titleMovie.alpha = value
        self.reviewDateTitle.alpha = value
        self.reviewAuthorTitle.alpha = value
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
