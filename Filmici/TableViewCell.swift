//
//  TableViewCell.swift
//  Filmici
//
//  Created by D&M on 21.02.2017..
//  Copyright © 2017. Dunja Sasic. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {



    @IBOutlet weak var MovieImage: UIImageView!
    @IBOutlet weak var MovieTitle: UILabel!
    
    //var allMovies
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}




